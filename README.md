# Data Warehouse Project: Building a Single Source of Truth

## Overview

This project focuses on designing and building a Data Warehouse that consolidates data from multiple operational systems into a centralized and reliable **single source of truth** for analytics and reporting.

The warehouse integrates data from ERP and CRM systems, transforms raw data into business-ready datasets, and prepares the data for downstream Business Intelligence and reporting solutions.

The project was built to strengthen practical skills in:
- Data Warehousing
- ETL Development
- Dimensional Modeling
- SQL Transformations
- Business-Oriented Analytics Engineering

---

# Problem Statement

Organizations often store business data across multiple systems, making reporting inconsistent, fragmented, and difficult to manage.

This project addresses that challenge by:
- consolidating ERP and CRM datasets
- cleaning and transforming raw data
- standardizing business entities
- creating analytical models optimized for reporting and decision-making

---

# Objectives

- Build a centralized data warehouse
- Create a scalable Medallion Architecture
- Develop business-ready analytical models
- Implement dimensional modeling using Star Schema
- Prepare datasets for Business Intelligence tools
- Create a foundation for future analytics engineering workflows

---

# Tech Stack

| Component | Tool |
|-----------|------|
| Database | PostgreSQL |
| Transformation | SQL Stored Procedures |
| Data Modeling | Star Schema |
| Diagramming | draw.io |
| Project Management | Notion |
| Version Control | Git & GitHub |

---

# Data Warehouse Architecture

The project follows the **Medallion Architecture** design pattern.

## Bronze Layer (Raw Data)

- Stores raw ERP and CRM data
- No transformations applied
- Preserves source-system structure

### Purpose
- Data ingestion
- Historical preservation
- Raw source replication

---

## Silver Layer (Cleaned & Transformed Data)

This layer performs:
- Data cleaning
- Standardization
- Null handling
- Duplicate removal
- Data type corrections
- Business rule transformations

### Transformation Logic
- SQL stored procedures
- Left joins
- Full load processing

---

## Gold Layer (Business Data Model)

The Gold Layer contains business-ready analytical models designed for reporting and BI tools.

### Features
- Star Schema design
- Fact and Dimension tables
- Business-oriented structure
- Optimized analytical querying

---

# ETL Workflow
![High Level Architecture](./docs/High%20Level%20Architecture.png)

## Data Flow

```text
ERP / CRM Source Systems
        ↓
Bronze Layer (Raw Data)
        ↓
Silver Layer (Cleaned & Transformed)
        ↓
Gold Layer (Business Data Model)

        ↓
Business Intelligence Tools
```
## Data Mart Diagram
![Star Schema](./docs/Data%20Mart%20(Star%20schema).png)

# Additional Design Decisions

## Naming Conventions

The project follows a consistent **snake_case** naming convention across:
- schemas
- tables
- columns
- stored procedures

### Examples
- gold.fact_sales
- gold.dim_customers
- sales_amount
- customer_key

This improves readability, consistency, and maintainability across the warehouse.

---

## Slowly Changing Dimensions (SCD)

This project currently implements dimensions **without historization**.

### SCD Approach
- Type: No historization / overwrite approach
- Existing dimension records are updated directly
- Historical attribute changes are not preserved

### Future Improvement
Future versions of the warehouse may implement:
- Slowly Changing Dimension Type 2 (SCD2)
- Historical tracking
- Effective and expiration dates
- Current record indicators
- Applying dbt to stage all transformations enabling modular
- Creating a Dashboard to enable busines decisons
- Generating a Report for all stake holders