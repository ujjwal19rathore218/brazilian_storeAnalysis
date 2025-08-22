import sqlite3
import pandas as pd

conn = sqlite3.connect("olist.db")

# Example for dim_orders
df = pd.read_sql("SELECT * FROM dim_orders", conn)
print("Null values in dim_orders:")
print(df.isnull().sum())

dup_count = df.duplicated().sum()
print(f"Duplicate rows in dim_orders: {dup_count}")

print("the data types ",df.dtypes)

print(df.head(10))
