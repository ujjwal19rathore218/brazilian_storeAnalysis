import pandas as pd
import sqlite3

# Connect to database
conn = sqlite3.connect("../olist.db")  # Update if needed
cursor = conn.cursor()

# ✅ Step 1: Read order data to get min and max dates
orders_df = pd.read_csv("../data/raw/olist_orders_dataset.csv", usecols=["order_purchase_timestamp"])
orders_df["order_purchase_timestamp"] = pd.to_datetime(orders_df["order_purchase_timestamp"])

min_date = orders_df["order_purchase_timestamp"].min().date()
max_date = orders_df["order_purchase_timestamp"].max().date()

print(f"Date range: {min_date} to {max_date}")

# ✅ Step 2: Generate full date range
date_range = pd.date_range(start=min_date, end=max_date)

# ✅ Step 3: Create dim_calendar DataFrame
calendar_df = pd.DataFrame({"date": date_range})
calendar_df["year"] = calendar_df["date"].dt.year
calendar_df["quarter"] = calendar_df["date"].dt.to_period("Q").astype(str)
calendar_df["month"] = calendar_df["date"].dt.month
calendar_df["week"] = calendar_df["date"].dt.isocalendar().week
calendar_df["day"] = calendar_df["date"].dt.day
calendar_df["weekday"] = calendar_df["date"].dt.day_name()
calendar_df["is_weekend"] = calendar_df["weekday"].isin(["Saturday", "Sunday"]).astype(int)

# Convert date to string format for SQLite
calendar_df["date"] = calendar_df["date"].dt.strftime("%Y-%m-%d")

# ✅ Step 4: Insert into SQLite
calendar_df.to_sql("dim_calendar", conn, if_exists="replace", index=False)

print(f"✅ dim_calendar created with {len(calendar_df)} rows.")

conn.close()
# Close the database connection