# Brazilian Store Analysis

This project focuses on analyzing and transforming the data from a Brazilian e-commerce store (Olist) to derive business insights and build a data model for robust analytics. The repository covers the full data pipeline: loading raw data into a database, cleaning and validating data, and exploring the data through notebooks to generate key performance indicators (KPIs).

## Project Structure

- **sql/**: Contains scripts for loading (`load.py`), cleaning (`clean.py`), and testing KPIs (`test_kpi.py`) in the SQLite database.
- **notebooks/**: Jupyter notebooks for exploratory data analysis (EDA) and visualization.
- **validation.py**: Script for validating data integrity (e.g., checking for nulls and duplicates) in important tables.

## Main Features

- **Data Loading**: Loads multiple CSV files into a SQLite database (`olist.db`) as fact and dimension tables (orders, customers, products, sellers, payments, reviews).
- **Data Cleaning**: Removes duplicates, handles missing values (e.g., unknown order status), and ensures consistent data types.
- **Data Validation**: Checks for nulls, duplicates, and displays data types for key tables.
- **Calendar Table Generation**: Creates a date dimension (`dim_calendar`) to enable time-based analysis.
- **KPI Calculation**: Generates business KPIs such as total revenue, monthly orders, average order value, delivery times, customer lifetime value, and repeat customer rate.
- **Exploratory Analysis**: Jupyter notebooks walk through the step-by-step process of analyzing orders, products, payments, and customer metrics.

## Example KPIs

- Total Revenue
- Total Orders
- Monthly Revenue & Orders
- Top Product Categories
- Average Delivery Time
- Payment Type Breakdown
- Order Status Breakdown
- Repeat Customer Rate
- Revenue per Customer
- Customer Lifetime Value

## Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/ujjwal19rathore218/brazilian_storeAnalysis.git
   cd brazilian_storeAnalysis
   ```
2. **Install dependencies**:
   ```bash
   pip install pandas sqlite3
   ```
3. **Prepare raw data**: Place the Olist CSV datasets in the `data/raw/` directory.
4. **Run the loading script**:
   ```bash
   python sql/load.py
   ```
5. **Clean and validate data**:
   ```bash
   python sql/clean.py
   python validation.py
   ```
6. **Explore KPIs**:
   - Execute `sql/test_kpi.py` to preview KPI views.
   - Open `notebooks/eda_02.ipynb` for EDA and visualization.

## Requirements

- Python 3.x
- pandas
- sqlite3

## Data Source

This project uses the [Olist E-Commerce Public Dataset](https://www.kaggle.com/olistbr/brazilian-ecommerce).

## Author

[ujjwal19rathore218](https://github.com/ujjwal19rathore218)

---

Feel free to contribute or open issues for enhancements!
