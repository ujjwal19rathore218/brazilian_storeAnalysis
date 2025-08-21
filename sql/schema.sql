-- Fact Tables
CREATE TABLE IF NOT EXISTS fact_order_items (
    order_id TEXT,
    order_item_id INTEGER,
    product_id TEXT,
    seller_id TEXT,
    shipping_limit_date TEXT,
    price REAL,
    freight_value REAL
);

CREATE TABLE IF NOT EXISTS fact_payments (
    order_id TEXT,
    payment_sequential INTEGER,
    payment_type TEXT,
    payment_installments INTEGER,
    payment_value REAL
);

CREATE TABLE IF NOT EXISTS fact_reviews (
    review_id TEXT,
    order_id TEXT,
    review_score INTEGER,
    review_creation_date TEXT,
    review_answer_timestamp TEXT
);

-- Dimension Tables
CREATE TABLE IF NOT EXISTS dim_orders (
    order_id TEXT,
    customer_id TEXT,
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT,
    order_estimated_delivery_date TEXT
);

CREATE TABLE IF NOT EXISTS dim_customers (
    customer_id TEXT,
    customer_unique_id TEXT,
    customer_zip_code_prefix TEXT,
    customer_city TEXT,
    customer_state TEXT
);

CREATE TABLE IF NOT EXISTS dim_products (
    product_id TEXT,
    product_category_name TEXT,
    product_name_length INTEGER,
    product_description_length INTEGER,
    product_photos_qty INTEGER,
    product_weight_g REAL,
    product_length_cm REAL,
    product_height_cm REAL,
    product_width_cm REAL
);

CREATE TABLE IF NOT EXISTS dim_sellers (
    seller_id TEXT,
    seller_zip_code_prefix TEXT,
    seller_city TEXT,
    seller_state TEXT
);

CREATE TABLE IF NOT EXISTS dim_calendar (
    date TEXT PRIMARY KEY,
    year INTEGER,
    quarter TEXT,
    month INTEGER,
    week INTEGER,
    day INTEGER,
    weekday TEXT,
    is_weekend INTEGER
);
