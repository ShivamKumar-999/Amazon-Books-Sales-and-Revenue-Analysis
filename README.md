# 📦 Amazon Books — Sales Intelligence Dashboard


**Amazon Books Sales Intelligence Dashboard — Revenue Analytics & Growth Strategy**
*(Python · SQL · Chart.js · Business Intelligence · E-commerce Analytics)*

---
## Overview

This project analyzes real-world Amazon Books sales data from a publishing business to identify revenue drivers, category performance, sales trends, and business growth opportunities.
The goal was to convert raw transaction data into actionable business insights using SQL, Excel, Python, and an interactive HTML dashboard.
This project focuses on decision-making, not just reporting — highlighting where revenue comes from, where profit leaks happen, and how business performance can be improved.

## 📊 Problem Statement

An Amazon book seller operating across 4+ years and 673 titles had no visibility into which products were actually driving margin, what was causing seasonal revenue spikes, and whether the 28.1% Amazon platform cut was eating disproportionately into profits on certain SKUs.

Decisions on pricing, bundling, and catalog pruning were being made without data — leading to missed revenue opportunities and wasted catalog management effort on zero-contribution titles.

---

## 🎯 Objective

- Build an end-to-end sales intelligence dashboard covering **5 business domains** and answering **15 specific business questions**
- Identify the revenue-to-margin gap across categories and individual titles
- Quantify seasonal demand patterns tied to competitive exam cycles
- Simulate pricing and bundling scenarios to project incremental revenue uplift
- Apply Pareto analysis to recommend catalog pruning for operational efficiency

---

## 🗂️ Dataset

| Attribute | Detail |
|---|---|
| **Source** | Amazon Seller Central transaction exports |
| **Time Period** | June 2021 – February 2025 (4+ years) |
| **Size** | 14,339 transactions · 673 unique titles |
| **Key Columns** | `order_date`, `title`, `category`, `gross_revenue`, `net_revenue`, `platform_cut`, `units_sold`, `price_per_unit` |
| **Currency** | INR (₹) |
| **Key Derived Fields** | `margin_per_unit`, `days_active`, `net_per_unit`, `moving_avg_revenue`, `co_purchase_pairs` |

---

## 🛠️ Tools & Technologies

**Analytics & Processing**
- Python (Pandas, NumPy) — data cleaning, aggregation, feature engineering
- SQL — order-level grouping, co-purchase pair analysis, date-dimension joins

**Visualization & Dashboard**
- Chart.js — interactive multi-chart dashboard (line, bar, donut, scatter)
- HTML5 / CSS3 / JavaScript — responsive single-page dashboard application
- IBM Plex Mono · Sora — professional typography for financial readability

**Business Intelligence Techniques**
- Pareto / 80-20 Analysis — catalog contribution scoring
- Time Series Analysis — monthly trend + 3-month moving average
- Cohort Segmentation — category-level gross vs net comparison
- Pricing Simulation — demand-inelastic revenue uplift modeling
- Co-purchase / Market Basket Analysis — bundle opportunity identification
Raw Data
   ↓
Python (Import + Cleaning + EDA)
   ↓
SQL Database Loading
   ↓
SQL Business Analysis
   ↓
Dashboard Development
   ↓
Business Insights & Recommendations
---

## 🔍 Key Steps / Methodology

### Phase 1 — Data Preparation
- Ingested 14,339 Amazon Seller Central transaction rows across 4+ years
- Standardized date formats and derived month, quarter, and year dimension fields
- Calculated `platform_cut_pct` per transaction to validate against Amazon's published fee structure
- Engineered `net_per_unit` = `net_revenue / units_sold` for margin comparison across SKUs

### Phase 2 — Exploratory Data Analysis (EDA)
- Profiled gross vs net revenue gap (28.1% platform cut = ₹35.5L retained by Amazon)
- Identified category concentration: top 2 of 4 categories = 92.4% of all net revenue
- Detected seasonal spikes correlating with UGC NET / TGT-PGT exam notification cycles
- Measured daily run-rate: ₹8,520 net/day · 13.5 orders/day · 1,065 trading days

### Phase 3 — Product Performance Analysis
- Ranked 673 titles by units sold, net revenue, and margin-per-unit (not just volume)
- Identified the **volume ≠ profit paradox**: top unit-seller earns ₹100/unit; a mid-volume title earns ₹505/unit
- Measured demand consistency: books with 200+ active selling days classified as institutionally recommended (price-inelastic)

### Phase 4 — Advanced Revenue Modeling
- **Pricing Simulation**: Modeled 10% price increase on top 5 titles → projected +₹2,79,035 additional net revenue
- **Bundle Analysis**: Identified 10 high-frequency co-purchase pairs from same-day order data
- **Pareto Catalog Audit**: Applied 80/20 rule — bottom 135 titles (20% of catalog) = only 0.3% of revenue (₹27,300)
- **Tiered Platform Cut Model**: Simulated 2% cut reduction on books priced above ₹1,000 → +₹1.4–1.8L/year uplift

### Phase 5 — Dashboard Development
- Built a 5-tab, 15-question interactive HTML dashboard using Chart.js
- Sections: Revenue & Sales · Category Performance · Product & Book Analysis · Daily Operations · Growth Lab
- Added business insight callouts in each section with actionable recommendations

---

## 📈 Key Insights / Results

### Revenue & Profitability
- **Total Gross Revenue**: ₹1.26 Cr | **Net Revenue**: ₹90.7L | **Platform Cut**: 28.1% (₹35.5L)
- **2023 was the peak year** at ₹25.6L net; 2024 declined 17% to ₹21.1L — signaling market maturity
- **Q1 and Q3 dominate** revenue — directly tied to UGC NET and TGT/PGT competitive exam cycles

### Category Intelligence
- Top 2 categories (Competitive Exam + Physical Education) generate **92.4% of all revenue**
- "Competitive Exam" leads at ₹49.8L net (54.8% share) with ₹656 avg net/unit
- "Other" category earns only ₹380/unit but has the lowest platform cut (16.9%) — a hidden repricing opportunity

### Product-Level Findings
- *Physical Education Universe* is the top unit-seller (1,250 units) but generates only ₹356/unit net
- *Physical Education - UGC Net Digest* (678 units) earns **3× the net per unit** (₹1,505/unit) — the true revenue driver
- Books with **200+ active selling days** show institutional demand — never discount these titles
- The highest-margin title (*UGC NET DIGEST Physical Education – Question Papers*) earns **₹2,300/unit** margin

### Operational Patterns
- Avg daily orders: **13.5** | Avg daily net revenue: **₹8,520**
- **Peak single day: 12 Aug 2023 — ₹41,075 net (4.8× daily average)** — triggered by UGC NET exam notification
- Top 15 revenue days are all concentrated in **Jun–Sep window** (exam prep season)

### Growth Opportunities Quantified
| Strategy | Projected Impact |
|---|---|
| 10% price increase on top 5 titles | +₹2,79,035/year net |
| Tiered cut reduction (2% on books >₹1,000) | +₹1.4–1.8L/year |
| Bundle upsell on top 10 co-purchase pairs | +₹15,000–₹58,000 est. |
| Reprice "Other" category from ₹380 to ₹500+ net | +₹2L+ annually |
| Prune 135 non-performing titles (<₹500/year net) | Operational cost saving |

---

## 📊 Visualizations / Dashboard

> **Dashboard Preview** — Amazon Books Sales Intelligence

The dashboard is organized into **5 tabs** covering **15 business questions**:

| Tab | Focus | Charts Used |
|---|---|---|
| ① Revenue & Sales | Gross vs Net, YoY, Quarterly | Line chart, Donut, Bar |
| ② Category Performance | Revenue share, Gross vs Net by category | Donut, Horizontal bar, Table |
| ③ Products & Books | Top 10 by volume, Top 10 by margin/unit | Horizontal bars, Ranked table |
| ④ Daily Operations | Monthly velocity, Spike days, Peak analysis | Line + moving avg, Bar |
| ⑤ Growth Lab | Pricing sim, Bundles, Pareto, Tiered cuts | Multi-dataset bars, Grouped analysis |

> 📎 *See `Amazon_Books_Dashboard.html` for the live interactive version*

---

## 🚀 Business Impact

This dashboard reframes how the seller makes decisions — moving from gut-feel catalog management to **data-driven margin optimization**:

1. **Pricing Strategy**: Identified that the top 5 titles can sustain a 10% price increase based on demand consistency data — translating to ₹2.79L additional annual revenue without adding a single new customer.

2. **Catalog Rationalization**: Revealed that 135 titles (20% of catalog) contribute just 0.3% of revenue — freeing up listing management time worth hundreds of hours/year when removed or bundled.

3. **Seasonal Planning**: Quantified the June–August exam prep demand window, enabling pre-positioned promotions and stock-up decisions 4–6 weeks in advance.

4. **Bundle Revenue Recovery**: Identified 10 high-frequency co-purchase book pairs that can be packaged as "Study Combo" bundles — increasing average order value without discounting individual titles.

5. **Margin Focus Shift**: The core finding — that volume leaders are often margin laggards — fundamentally changes which titles receive promotional priority and where ad spend should be allocated.

---

## 🔗 Project Link

- 🌐 **Live Dashboard**: [Amazon_Books_Dashboard.html]
- 💼 **LinkedIn Post**: `[https://www.linkedin.com/posts/shivam-kumar-6377492ba_new-data-analytics-project-amazon-books-activity-7464973264487014400-0JMi?utm_source=social_share_send&utm_medium=member_desktop_web&rcm=ACoAAEyj-EsBi0-OLOhViazDCaOrIqlPJL9NAD0]`

First tab(<img width="1905" height="757" alt="Screenshot 2026-05-26 150238" src="https://github.com/user-attachments/assets/839b68f2-f97c-4f36-84bc-6bf4845ca67c" />
)
