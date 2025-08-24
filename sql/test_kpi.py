import sqlite3
import pandas as pd

DB_PATH = "C:/Users/DeLL/OneDrive/New folder/olist.db"

def check_view_exists(conn, view_name):
    query = "SELECT name FROM sqlite_master WHERE type='view' AND name=?"
    return pd.read_sql(query, conn, params=(view_name,)).shape[0] > 0

def preview_view(conn, view_name, limit=5):
    print(f"\n🔍 Preview of {view_name}:")
    df = pd.read_sql(f"SELECT * FROM {view_name} LIMIT {limit}", conn)
    print(df)

with sqlite3.connect(DB_PATH) as conn:
    kpi_views = [
        "kpi_total_revenue", "kpi_total_orders", "kpi_avg_order_value",
        "kpi_monthly_revenue", "kpi_monthly_orders", "kpi_top_categories",
        "kpi_avg_delivery_time", "kpi_payment_type_breakdown",
        "kpi_order_status_breakdown", "kpi_repeat_customer_rate",
        "kpi_revenue_per_customer"
    ]
    
    for view in kpi_views:
        if check_view_exists(conn, view):
            preview_view(conn, view)
        else:
            print(f"❌ {view} does NOT exist. Check SQL execution.")
