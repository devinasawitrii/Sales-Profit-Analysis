# Sales & Profit Analysis Dashboard

An end-to-end data analytics project examining twelve months of sales and profit performance for an e-commerce business. The workflow covers data modeling in **BigQuery (SQL)**, exploratory analysis in **Python (Google Colab)**, and an interactive dashboard in **Looker Studio**.

**Live dashboard:** [View on Looker Studio](https://datastudio.google.com/u/0/reporting/757e8356-a055-45c9-b312-290c50ed1a4b/page/p_d54b3eh46d)

### Dashboard Preview

**Page 1: Performance Overview**

![Performance Overview](images/dashboard_overview.png)

**Page 2: Product & Category Performance**

![Product and Category Performance](images/dashboard_product_category.png)

---

## Business Questions

1. Which product categories generate the highest sales?
2. Which categories and products contribute the most profit?
3. Which products combine high sales with low or negative profit?
4. How do sales and profit trend month over month?

## Dataset

- Source: [Indian E-Commerce Sales & Customer Analytics](https://www.kaggle.com/) (Kaggle, CC0 1.0)
- Original scope: 100,000 orders, 25,000 customers, 550 products, 22 categories, 2023–2025
- Tables used: `orders`, `order_items`, `products`

| Table | Grain | Columns Used |
|---|---|---|
| `orders` | One row per order | `order_id`, `customer_id`, `order_date` |
| `order_items` | One row per order line item | `order_item_id`, `order_id`, `product_id`, `quantity`, `item_revenue`, `profit` |
| `products` | One row per product | `product_id`, `product_name`, `category` |

## Workflow

```
Kaggle CSV → BigQuery → SQL (CTEs, joins, filters) → Google Colab (pandas, matplotlib) → Looker Studio → Insights
```

### 1. SQL (BigQuery)

The query builds an analysis-ready table, `sales_profit_analysis`, in four steps:

1. Filter orders to the trailing twelve months ending 2025-12-31.
2. Keep only line items with `quantity > 0`.
3. Join orders, line items, and products with `INNER JOIN`.
4. Round `sales` and `profit` to two decimal places.

See [`sql/sales_profit_analysis.sql`](sql/sales_profit_analysis.sql).

### 2. Python (Google Colab)

The notebook connects Colab to BigQuery, removes duplicate line items by `order_item_id`, exploratory data analysis,  and aggregates results by category, product, and month. It also produces bar charts of sales and profit by category.

See [`notebooks/sales_profit_analysis.ipynb`](notebooks/sales_profit_analysis.ipynb).

## Dashboard Guide

The dashboard has two pages. Global filters for Category, Product, and Date Range apply to every chart. The date range is set to 1 Jan 2025 – 31 Dec 2025.

### Page 1: Performance Overview

| Chart | What It Shows | How to Read It |
|---|---|---|
| **Total Sales / Total Profit** (scorecards) | Aggregate sales and profit for the selected filters | Headline figures that update with every filter. |
| **Profit Margin** (gauge) | Total profit divided by total sales | Shows overall profitability at a glance (8.2% for the full year). |
| **Sales and Profit Trend** (line chart) | Sales and profit over time | Reveals seasonality and growth. Both series rise sharply toward year end, while profit stays far below sales. |
| **Sales and Profit Performance by Product** (scatter plot) | One point per product, with sales on the X axis and profit on the Y axis | Points near or below zero on the Y axis are low-margin or loss-making products. Hover over a point to identify the product. |

### Page 2: Product & Category Performance

| Chart | What It Shows | How to Read It |
|---|---|---|
| **Sales Contribution by Product Category** (donut chart) | Each category's share of total sales | Electronics alone contributes 49.8%, followed by Appliances at 16.8%. Smaller categories are grouped as "Others". |
| **Best Selling Product** (bar chart) | Top five products ranked by sales value | The smartwatch product leads by a wide margin, so sales are concentrated in a few products. |
| **Profit Contribution by Category** (treemap) | Each category's share of total profit, shown by area | Fashion and Home & Kitchen occupy the largest areas. Electronics is small despite leading in sales. |
| **Most Profitable Product** (bar chart) | Top five products ranked by profit | Only two products (the smartwatch and the storage & container product) appear in both top-five rankings, so most top sellers are not top profit earners. |

**Main takeaway:** comparing the donut chart with the treemap shows that sales rank and profit rank differ sharply across categories. Revenue-driving categories are not necessarily the most profitable ones.

## Key Metrics

| Metric | Value |
|---|---|
| Total Sales | 1,136,820,556.20 |
| Total Profit | 93,372,065.03 |
| Profit Margin | 8.21% |
| Line Items Analyzed | 118,002 |

## Key Insights

1. Electronics dominates sales. The category accounts for roughly 49.8% of total sales (565.8M) yet yields 5.8M in profit, a margin of about 1.0%.
2. Fashion is the largest profit contributor. It generates 21.4M in profit at a margin of about 33.2% and leads in volume (45,603 units), despite far lower sales than Electronics.
3. A single product drives a large share of revenue. Chaudhry, Advanced Smartwatche contributes 242.5M in sales (about 21% of the total) 5.3M in profit.
4. Several high-value products are unprofitable. Kala-Vaidya Deluxe Laptop (−1.40M), Handa Advanced Laptop (−0.80M), and Gola Essential Fans & Cooler (−0.26M) record losses despite strong sales.
5. Demand peaks in the fourth quarter. October–December 2025 represents about 46% of total sales. December 2025 is the strongest month, with 235.9M in sales and 18.6M in profit.

## Recommendations

- Review pricing, discounting, and cost structure for Electronics and Appliances products with thin or negative margins.
- Prioritize inventory and promotions for Fashion, Footwear, and Home & Kitchen, where margins are healthier.
- Plan stock and fulfillment capacity ahead of the fourth-quarter demand peak.

## Limitations

- **Scope of profit.** Returns, cancellations, and marketing costs are not modeled. Profit follows the `profit` field in `order_items` (item revenue minus item cost).
- **Currency.** The dataset does not specify a currency, so figures are shown without a currency symbol.

## Repository Structure

```
sales-profit-analysis-dashboard/
├── README.md
├── sales_profit_analysis.sql
├── sales_profit_analysis.ipynb
├── images/
   ├── dashboard_overview.png
   └── dashboard_product_category.png
```

## Tech Stack

BigQuery · SQL · Python (pandas, matplotlib) · Google Colab · Looker Studio · GitHub

