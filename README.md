# 📊 E-Commerce Sales & Profitability Analysis

## 📌 Project Overview

This project analyzes e-commerce sales, profitability, customer behavior, and product performance using SQL and Power BI.

The objective is to transform raw transactional data into meaningful business insights through data cleaning, SQL analysis, data modeling, DAX measures, and interactive Power BI dashboards.

---

## 🎯 Business Objectives

- Analyze overall sales and profitability
- Identify top-performing categories and sub-categories
- Analyze product profitability
- Understand customer segments and purchasing behavior
- Analyze sales performance by state
- Evaluate payment methods
- Analyze order and delivery performance
- Identify high-performing products and business areas

---

## 🛠️ Tools & Technologies

- **Power BI** – Dashboard development & data visualization
- **SQL / MySQL** – Data cleaning and business analysis
- **DAX** – KPI calculations and measures
- **Power Query** – Data transformation
- **Microsoft Excel** – Data preparation and validation

---

## 🗄️ Data Model

The project uses four main datasets:

- Customers
- Orders
- Order Details
- Products

### Relationships

```text
Customers
    │
    │ customer_id
    ▼
Orders
    │
    │ order_id
    ▼
Order Details
    │
    │ product_id
    ▼
Products
