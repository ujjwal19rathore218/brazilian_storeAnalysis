import sqlite3
import pandas as pd

DB_PATH = "olist.db"
conn = sqlite3.connect(DB_PATH)

# Read a table
df = pd.read_sql("SELECT * FROM dim_orders", conn)

# Apply cleaning
df.drop_duplicates(inplace=True)
df.fillna({"order_status": "unknown"}, inplace=True)
df['order_purchase_timestamp'] = pd.to_datetime(df['order_purchase_timestamp'], errors='coerce')

# Write back (replace old table)
df.to_sql("dim_orders", conn, if_exists="replace", index=False)

conn.close()
print("✅ Cleaning completed.")
