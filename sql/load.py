import pandas as pd
import sqlite3
import os

# Paths
BASE_DIR = r"C:\Users\DeLL\OneDrive\New folder\brazilian_storeAnalysis"
DB_PATH = os.path.join(BASE_DIR, "olist.db")
SCHEMA_PATH = os.path.join(BASE_DIR, "sql", "schema.sql")
DATA_DIR = os.path.join(BASE_DIR, "data", "raw")

# CSV to table mapping
csv_to_table = {
    "olist_orders_dataset.csv": "dim_orders",
    "olist_order_items_dataset.csv": "fact_order_items",
    "olist_order_payments_dataset.csv": "fact_payments",
    "olist_order_reviews_dataset.csv": "fact_reviews",
    "olist_customers_dataset.csv": "dim_customers",
    "olist_products_dataset.csv": "dim_products",
    "olist_sellers_dataset.csv": "dim_sellers"
}

# Connect to SQLite
conn = sqlite3.connect(DB_PATH)
cursor = conn.cursor()

# Apply schema.sql
with open(SCHEMA_PATH, "r", encoding="utf-8") as f:
    schema_sql = f.read()
cursor.executescript(schema_sql)
print("✅ Schema created successfully.")

# Load all fact & dimension tables
for csv_file, table in csv_to_table.items():
    csv_path = os.path.join(DATA_DIR, csv_file)

    # Read CSV
    df = pd.read_csv(csv_path)

    # Check DB columns
    cursor.execute(f"PRAGMA table_info({table})")
    db_columns = [col[1] for col in cursor.fetchall()]

    # Keep only columns that exist in DB
    df = df[[col for col in df.columns if col in db_columns]]

    # Special case for fact_reviews
    if table == "fact_reviews":
        df = df.drop(columns=[col for col in df.columns if col not in db_columns], errors='ignore')

    if not df.empty:
        df.to_sql(table, conn, if_exists="append", index=False)
        print(f"✅ Loaded {len(df)} rows into {table}")
    else:
        print(f"⚠️ Skipped {table}: No matching columns found")

# ✅ Generate dim_calendar after loading orders
orders_csv = os.path.join(DATA_DIR, "olist_orders_dataset.csv")
orders_df = pd.read_csv(orders_csv, usecols=["order_purchase_timestamp"])
orders_df["order_purchase_timestamp"] = pd.to_datetime(orders_df["order_purchase_timestamp"])

min_date = orders_df["order_purchase_timestamp"].min().date()
max_date = orders_df["order_purchase_timestamp"].max().date()
print(f"📅 Calendar range: {min_date} to {max_date}")

# Generate date range
date_range = pd.date_range(start=min_date, end=max_date)

calendar_df = pd.DataFrame({"date": date_range})
calendar_df["year"] = calendar_df["date"].dt.year
calendar_df["quarter"] = calendar_df["date"].dt.to_period("Q").astype(str)
calendar_df["month"] = calendar_df["date"].dt.month
calendar_df["week"] = calendar_df["date"].dt.isocalendar().week
calendar_df["day"] = calendar_df["date"].dt.day
calendar_df["weekday"] = calendar_df["date"].dt.day_name()
calendar_df["is_weekend"] = calendar_df["weekday"].isin(["Saturday", "Sunday"]).astype(int)

# Convert date to string for SQLite
calendar_df["date"] = calendar_df["date"].dt.strftime("%Y-%m-%d")

calendar_df.to_sql("dim_calendar", conn, if_exists="replace", index=False)
print(f"✅ dim_calendar created with {len(calendar_df)} rows")

# Commit and close
conn.commit()
conn.close()
print("🎯 All data + dim_calendar loaded into olist.db successfully!")
# End of script