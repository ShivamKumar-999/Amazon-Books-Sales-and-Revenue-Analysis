select*from amazon_sales limit(100);


--Revenue & Sales Performance

--Q1 What is the total gross revenue vs total net revenue (after_cut_charges) earned across all transactions — and what is the overall platform cut percentage?

SELECT 
    SUM(price_of_book * qty_of_book) AS gross_revenue,
    SUM(after_cut_charges_paybele) AS net_revenue,
    ROUND(
        ((SUM(price_of_book * qty_of_book) - SUM(after_cut_charges_paybele)) * 100.0 
        / SUM(price_of_book * qty_of_book)), 2
    ) AS platform_cut_percentage
FROM amazon_sales;


--Q2 Which book category generates the highest total net revenue, and what percentage share does each category hold of overall revenue?

SELECT 
    book_category,
    SUM(after_cut_charges_paybele) AS total_net_revenue,
    ROUND(
        SUM(after_cut_charges_paybele) * 100.0 / 
        (SELECT SUM(after_cut_charges_paybele) FROM amazon_sales), 2
    ) AS revenue_share_pct
FROM amazon_sales
GROUP BY book_category
ORDER BY total_net_revenue DESC;


--Q3 What is the total number of units sold and total net revenue broken down by month and quarter — which period was the strongest?

SELECT 
    year,
    quarter,
    month,
    SUM(qty_of_book) AS total_units_sold,
    SUM(after_cut_charges_paybele) AS total_net_revenue
FROM amazon_sales
GROUP BY year, quarter, month
ORDER BY total_net_revenue DESC;



-- Product & Book Performance

--Q4 Which are the top 10 best-selling books by total units sold — and for each, what is the net revenue contributed?

SELECT 
    book_title,
    SUM(qty_of_book) AS total_units_sold,
    SUM(after_cut_charges_paybele) AS net_revenue
FROM amazon_sales
GROUP BY book_title
ORDER BY total_units_sold DESC
LIMIT 10;


--Q5 Which books have the highest average net margin per copy (price_of_book minus after_cut_charges) — i.e., where is the platform cut the largest in absolute rupee terms?

SELECT 
    book_title,
    ROUND(AVG(price_of_book - after_cut_charges_paybele), 2) AS avg_net_margin_per_copy
FROM amazon_sales
GROUP BY book_title
ORDER BY avg_net_margin_per_copy DESC;



--Q6 Which books appear in the most purchase dates (i.e., selling consistently every day) vs books that only sold on one or two days — what does this tell us about demand stability?

SELECT 
    book_title,
    COUNT(DISTINCT purchase_date) AS selling_days
FROM amazon_sales
GROUP BY book_title
ORDER BY selling_days DESC;



-- Daily Sales & Order Patterns

--Q7 What is the average number of orders and average net revenue generated per day — and which specific dates were outlier high-volume days?

WITH daily_sales AS (
    SELECT 
        purchase_date::date AS sale_date,
        COUNT(*) AS total_orders,
        SUM(after_cut_charges_paybele) AS net_revenue
    FROM amazon_sales
    GROUP BY purchase_date::date
)
SELECT *
FROM daily_sales
WHERE total_orders > (SELECT AVG(total_orders) FROM daily_sales)
   OR net_revenue > (SELECT AVG(net_revenue) FROM daily_sales)
ORDER BY net_revenue DESC;


--Q8 How many orders contain only General Physical Education books vs only Competitive Exam books vs a mix — what does the order composition look like?

WITH order_type AS (
    SELECT
        purchase_date::date,
        CASE
            WHEN COUNT(DISTINCT book_category) = 1 
                 AND MAX(book_category) = 'General Physical Education'
                THEN 'Only General Physical Education'
            WHEN COUNT(DISTINCT book_category) = 1 
                 AND MAX(book_category) = 'PE Competitive Exam Books (UGC/TGT/PGT)'
                THEN 'Only Competitive Exam Books'
            ELSE 'Mix'
        END AS order_composition
    FROM amazon_sales
    GROUP BY purchase_date::date
)
SELECT 
    order_composition,
    COUNT(*) AS total_orders
FROM order_type
GROUP BY order_composition;


--Q9 On the highest revenue day, which books drove that spike — and can we identify if a specific book title caused the surge?

WITH top_day AS (
    SELECT purchase_date::date AS sale_date
    FROM amazon_sales
    GROUP BY purchase_date::date
    ORDER BY SUM(after_cut_charges_paybele) DESC
    LIMIT 1
)
SELECT 
    book_title,
    SUM(qty_of_book) AS units_sold,
    SUM(after_cut_charges_paybele) AS net_revenue
FROM amazon_sales
WHERE purchase_date::date = (SELECT sale_date FROM top_day)
GROUP BY book_title
ORDER BY net_revenue DESC;


--Q10 What is the revenue trend across the all years (start to end  ) — is sales velocity increasing, decreasing, or flat day over day?

SELECT 
    year,
    quarter,
    SUM(after_cut_charges_paybele) AS revenue,
    LAG(SUM(after_cut_charges_paybele)) OVER (ORDER BY year, quarter) AS prev_revenue,
    SUM(after_cut_charges_paybele)
    - LAG(SUM(after_cut_charges_paybele)) OVER (ORDER BY year, quarter) AS revenue_change,
    CASE
        WHEN SUM(after_cut_charges_paybele)
           > LAG(SUM(after_cut_charges_paybele)) OVER (ORDER BY year, quarter)
        THEN 'Profit'
        WHEN SUM(after_cut_charges_paybele)
           < LAG(SUM(after_cut_charges_paybele)) OVER (ORDER BY year, quarter)
        THEN 'Loss'
        ELSE 'Flat'
    END AS trend
FROM amazon_sales
GROUP BY year, quarter
ORDER BY year, quarter;




	
--Q11 If we increased the price of the top 5 highest-volume books by 10%, what would the projected revenue uplift be — using current volume as the baseline?

WITH top_5 AS (
    SELECT 
        book_title,
        SUM(qty_of_book) AS total_qty,
        AVG(price_of_book) AS avg_price
    FROM amazon_sales
    GROUP BY book_title
    ORDER BY total_qty DESC
    LIMIT 5
)
SELECT 
    book_title,
    total_qty,
    ROUND(avg_price * total_qty, 2) AS current_revenue,
    ROUND((avg_price * 1.10) * total_qty, 2) AS projected_revenue,
    ROUND(((avg_price * 1.10) * total_qty) - (avg_price * total_qty), 2) AS revenue_uplift
FROM top_5;


--Q12 Which book categories have a high volume of sales but a disproportionately low net revenue per unit — indicating a pricing gap or margin leakage opportunity worth fixing?

SELECT 
    book_category,
    SUM(qty_of_book) AS total_units_sold,
    ROUND(SUM(after_cut_charges_paybele) * 1.0 / SUM(qty_of_book), 2) AS net_revenue_per_unit
FROM amazon_sales
GROUP BY book_category
ORDER BY total_units_sold DESC, net_revenue_per_unit ASC;


--Q13 Which books are frequently purchased together on the same date (potential bundling pairs) 
-- and what would combined bundle revenue look like if bundled at a 5% discount vs selling separately?

WITH pairs AS (
    SELECT 
        a.book_title AS book1,
        b.book_title AS book2,
        COUNT(*) AS times_bought_together,
        SUM(a.after_cut_charges_paybele + b.after_cut_charges_paybele) AS current_revenue
    FROM amazon_sales a
    JOIN amazon_sales b
        ON a.purchase_date = b.purchase_date
       AND a.book_title < b.book_title
    GROUP BY a.book_title, b.book_title
)
SELECT 
    book1,
    book2,
    times_bought_together,
    ROUND(current_revenue, 2) AS current_revenue,
    ROUND(current_revenue * 0.95, 2) AS bundle_revenue_5pct_discount
FROM pairs
ORDER BY times_bought_together DESC;


--Q14 What is the rank of each book by net revenue contribution 
-- and which bottom 20% of books (by revenue) are consuming catalog space while contributing less than 5% of total revenue?

WITH book_rev AS (
    SELECT 
        book_title,
        SUM(after_cut_charges_paybele) AS net_revenue,
        RANK() OVER (ORDER BY SUM(after_cut_charges_paybele) DESC) AS revenue_rank
    FROM amazon_sales
    GROUP BY book_title
),
ranked AS (
    SELECT *,
           NTILE(5) OVER (ORDER BY net_revenue) AS revenue_bucket
    FROM book_rev
)
SELECT 
    book_title,
    net_revenue,
    revenue_rank
FROM ranked
WHERE revenue_bucket = 1
  AND net_revenue < (SELECT SUM(after_cut_charges_paybele)*0.05 FROM amazon_sales)
ORDER BY net_revenue;


--Q15 If we applied a tiered discount strategy — reducing the platform cut by 2% only on books priced above ₹1,000 to incentivize higher-priced purchases —
-- what would the net revenue impact be vs the current model?

SELECT 
    ROUND(SUM(after_cut_charges_paybele), 2) AS current_net_revenue,
    ROUND(
        SUM(
            CASE 
                WHEN price_of_book > 1000 
                THEN after_cut_charges_paybele + (price_of_book * 0.02)
                ELSE after_cut_charges_paybele
            END
        ), 2
    ) AS new_net_revenue,
    ROUND(
        SUM(
            CASE 
                WHEN price_of_book > 1000 
                THEN (price_of_book * 0.02)
                ELSE 0
            END
        ), 2
    ) AS net_revenue_impact
FROM amazon_sales;






Project Title: Amazon Books Sales & Revenue Analysis using SQL

Skills Used:

-- PostgreSQL
-- Window Functions
-- CTEs
-- Revenue Analysis
-- Pricing Simulation
-- Business Insights
-- KPI Reporting

Business Outcome:
-- Identified revenue concentration, pricing opportunities, catalog optimization, and growth strategy leading to better decision-making.
























































































