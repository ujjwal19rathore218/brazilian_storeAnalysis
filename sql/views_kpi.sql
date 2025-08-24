-- 1. Total Revenue
/*CREATE VIEW IF NOT EXISTS v_total_revenue AS
SELECT 
    SUM(price + freight_value) AS total_revenue
FROM fact_order_items;

-- 2. Number of Orders
CREATE VIEW IF NOT EXISTS v_total_orders AS
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM dim_orders;

-- 3. Average Order Value (AOV)
CREATE VIEW IF NOT EXISTS v_aov AS
SELECT 
    (SELECT SUM(price + freight_value) FROM fact_order_items) * 1.0 /
    (SELECT COUNT(DISTINCT order_id) FROM dim_orders) AS avg_order_value;

-- 4. Monthly Revenue Trend
CREATE VIEW IF NOT EXISTS v_monthly_revenue AS
SELECT 
    strftime('%Y-%m', d.order_purchase_timestamp) AS month,
    SUM(oi.price + oi.freight_value) AS monthly_revenue
FROM dim_orders d
JOIN fact_order_items oi ON d.order_id = oi.order_id
GROUP BY month
ORDER BY month;

-- 5. Top 10 Product Categories by Revenue
CREATE VIEW IF NOT EXISTS v_top_categories AS
SELECT 
    p.product_category_name,
    SUM(oi.price + oi.freight_value) AS category_revenue
FROM fact_order_items oi
JOIN dim_products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY category_revenue DESC
LIMIT 10;

-- 6. Average Delivery Time (in days)
CREATE VIEW IF NOT EXISTS v_avg_delivery_time AS
SELECT 
    AVG(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)) AS avg_delivery_days
FROM dim_orders
WHERE order_delivered_customer_date IS NOT NULL;

-- 7. Payment Type Breakdown
CREATE VIEW IF NOT EXISTS v_payment_type_breakdown AS
SELECT 
    payment_type,
    COUNT(*) AS count,
    ROUND(SUM(payment_value), 2) AS total_amount
FROM fact_payments
GROUP BY payment_type
ORDER BY total_amount DESC;

-- 8. Order Status Breakdown
CREATE VIEW IF NOT EXISTS v_order_status_breakdown AS
SELECT 
    order_status,
    COUNT(*) AS status_count
FROM dim_orders
GROUP BY order_status;
*/
-- 1. Total Revenue

DROP VIEW IF EXISTS kpi_total_revenue;
DROP VIEW IF EXISTS kpi_total_orders;
DROP VIEW IF EXISTS kpi_avg_order_value;
DROP VIEW IF EXISTS kpi_monthly_revenue;
DROP VIEW IF EXISTS kpi_monthly_orders;
DROP VIEW IF EXISTS kpi_top_categories;
DROP VIEW IF EXISTS kpi_avg_delivery_time;
DROP VIEW IF EXISTS kpi_payment_type_breakdown;
DROP VIEW IF EXISTS kpi_order_status_breakdown;
DROP VIEW IF EXISTS kpi_repeat_customer_rate;
DROP VIEW IF EXISTS kpi_revenue_per_customer;

CREATE VIEW IF NOT EXISTS kpi_total_revenue AS
SELECT 
    ROUND(SUM(price + freight_value), 2) AS total_revenue
FROM fact_order_items;

-- 2. Total Orders
CREATE VIEW IF NOT EXISTS kpi_total_orders AS
SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM dim_orders;

-- 3. Average Order Value (AOV)
CREATE VIEW IF NOT EXISTS kpi_avg_order_value AS
SELECT 
    ROUND(
        (SELECT SUM(price + freight_value) FROM fact_order_items) * 1.0 /
        (SELECT COUNT(DISTINCT order_id) FROM dim_orders), 2
    ) AS avg_order_value;

-- 4. Monthly Revenue Trend (using dim_calendar)
CREATE VIEW IF NOT EXISTS kpi_monthly_revenue AS
SELECT 
    strftime('%Y-%m', d.order_purchase_timestamp) AS year_month,
    SUM(oi.price + oi.freight_value) AS monthly_revenue
FROM dim_orders d
JOIN fact_order_items oi ON d.order_id = oi.order_id
GROUP BY year_month
ORDER BY year_month;


-- 5. Monthly Orders Trend
CREATE VIEW IF NOT EXISTS kpi_monthly_orders AS
SELECT 
    strftime('%Y-%m', d.order_purchase_timestamp) AS year_month,
    COUNT(DISTINCT d.order_id) AS monthly_orders
FROM dim_orders d
GROUP BY year_month
ORDER BY year_month;


-- 6. Top 10 Product Categories by Revenue
CREATE VIEW IF NOT EXISTS kpi_top_categories AS
SELECT 
    p.product_category_name,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS category_revenue
FROM fact_order_items oi
JOIN dim_products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY category_revenue DESC
LIMIT 10;

-- 7. Average Delivery Time (days)
CREATE VIEW IF NOT EXISTS kpi_avg_delivery_time AS
SELECT 
    ROUND(AVG(julianday(order_delivered_customer_date) - julianday(order_purchase_timestamp)), 2) AS avg_delivery_days
FROM dim_orders
WHERE order_delivered_customer_date IS NOT NULL;

-- 8. Payment Type Breakdown
CREATE VIEW IF NOT EXISTS kpi_payment_type_breakdown AS
SELECT 
    payment_type,
    COUNT(*) AS count,
    ROUND(SUM(payment_value), 2) AS total_amount
FROM fact_payments
GROUP BY payment_type
ORDER BY total_amount DESC;

-- 9. Order Status Breakdown
CREATE VIEW IF NOT EXISTS kpi_order_status_breakdown AS
SELECT 
    order_status,
    COUNT(*) AS status_count
FROM dim_orders
GROUP BY order_status
ORDER BY status_count DESC;

-- 10. Repeat Customer Rate
CREATE VIEW IF NOT EXISTS kpi_repeat_customer_rate AS
SELECT 
    ROUND(
        (CAST(SUM(CASE WHEN order_count > 1 THEN 1 ELSE 0 END) AS FLOAT) /
        COUNT(*)) * 100, 2
    ) AS repeat_customer_rate
FROM (
    SELECT customer_id, COUNT(*) AS order_count
    FROM dim_orders
    GROUP BY customer_id
);

-- 11. Revenue Per Customer
CREATE VIEW IF NOT EXISTS kpi_revenue_per_customer AS
SELECT 
    ROUND(SUM(price + freight_value) / COUNT(DISTINCT d.customer_id), 2) AS revenue_per_customer
FROM fact_order_items oi
JOIN dim_orders d ON oi.order_id = d.order_id;
