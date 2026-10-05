-- 1. Cek Products
SELECT *
FROM `portof-510606.ecommerce.products`
LIMIT 10;

-- 2. Cek Orders
SELECT *
FROM `portof-510606.ecommerce.orders`
LIMIT 10;

-- 3. Cek Order Items
SELECT *
FROM `portof-510606.ecommerce.order_items`
LIMIT 10;


-- Sales & Profit Analysis
-- Gabungkan order, item, dan produk untuk analisis penjualan

CREATE OR REPLACE TABLE `portof-510606.ecommerce.sales_profit_analysis` AS

-- Filter order 1 tahun terakhir
WITH orders_clean AS (
    SELECT
        order_id,
        customer_id,
        DATE(order_date) AS order_date
    FROM `portof-510606.ecommerce.orders`
    WHERE DATE(order_date) >= DATE_SUB(DATE '2025-12-31', INTERVAL 1 YEAR)
      AND DATE(order_date) <= DATE '2025-12-31'
),

-- Ambil item dengan quantity yang valid
order_items_clean AS (
    SELECT
        order_item_id,
        order_id,
        product_id,
        quantity,
        item_revenue,
        profit
    FROM `portof-510606.ecommerce.order_items`
    WHERE quantity > 0
),

-- Ambil informasi produk
products_clean AS (
    SELECT
        product_id,
        product_name,
        category
    FROM `portof-510606.ecommerce.products`
)

-- Gabungkan ketiga tabel
SELECT
    o.order_id,
    o.order_date,
    o.customer_id,
    oi.order_item_id,
    p.product_id,
    p.product_name,
    p.category,
    oi.quantity,
    ROUND(oi.item_revenue, 2) AS sales,
    ROUND(oi.profit, 2) AS profit

FROM orders_clean AS o

INNER JOIN order_items_clean AS oi
    ON o.order_id = oi.order_id

INNER JOIN products_clean AS p
    ON oi.product_id = p.product_id;