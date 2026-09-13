# Bank Loan Portfolio & Credit Risk Analytics Platform

## Executive Summary
An end-to-end data analytics and business intelligence solution evaluating credit deployment, liquidity trends, and default exposure across **$435.8M** in funded loan capital and **38,576** loan records[cite: 3]. Built with a dual-system architecture pairing **MS SQL Server** for backend data staging and ground-truth validation with **Microsoft Power BI** for multi-tiered interactive reporting[cite: 3].

## Architecture & Data Pipeline
```text
[ Raw Financial Dataset (38.5k rows) ]
          │
    ┌─────┴─────────────────────────────────────┐
    ▼ (System A: SQL Ground Truth)              ▼ (System B: Power BI BI Engine)
[ MS SQL Server Staging ]               [ Power Query Data Profiling ]
    │ (Type casting, PKs, indexing)             │ (Null audit, type casting)
    ▼                                           ▼
[ Baseline Query Validation ]           [ Star Schema Data Model ]
    │ (MTD, MoM%, Risk segments)                │ (Calendar dimension, 1-to-many relationship)
    │                                           ▼
    │                                   [ DAX Measure Engine ]
    │                                           │ (TOTALMTD, DATEADD, Dynamic Parameters)
    │                                           ▼
    │                                   [ 3-Page Executive Dashboard ]
    └──────────────► [ Line-by-Line QA Parity ] ◄────────┘
```

## Key Technical Implementations

### 1. Database Staging & SQL Baseline Testing (MS SQL Server)
* **Schema Staging & Tuning:** Staged 38,576 records across 24 attributes, setting non-null Primary Key constraints and casting data types (`VARCHAR(100)` for job titles, `INT` for loan amounts) to prevent numeric overflow[cite: 3].
* **Baseline Validation Queries:** Authored non-visual SQL queries calculating total loan volume, funded capital, collections, interest rate averages, and DTI ratios prior to front-end ingestion[cite: 3].
* **Time-Intelligence Filtering:** Isolated Month-to-Date (MTD) and Prior Month-to-Date (PMTD) figures directly via SQL date filtering logic[cite: 3].

### 2. ETL & DAX Modeling (Microsoft Power BI)
* **Star Schema:** Linked a central transaction fact table to an autonomous continuous Date/Calendar dimension in a 1-to-many single-direction relationship[cite: 3].
* **DAX Measure Engine:** Programmed time-intelligence measures (`TOTALMTD`, `DATEADD`, `DATESMTD`, `CALCULATE`) to isolate period-over-period performance metrics[cite: 3]:
  $$\text{MoM\% Growth} = \frac{\text{MTD Value} - \text{PMTD Value}}{\text{PMTD Value}}$$[cite: 3]
* **3-Page Multi-Tiered Layout:**
  * **Summary View:** Executive-level KPI status tracking and Good vs. Bad loan distribution cards[cite: 3].
  * **Overview View:** Dynamic Field Parameters toggling visual breakdowns across loan term, purpose, home ownership, and state distribution[cite: 3].
  * **Details View:** High-density audit grid enabling granular transaction inspections, multi-slicing, and data export[cite: 3].

## Portfolio Performance Metrics Summary

| Portfolio Metric | Total Value | Month-to-Date (MTD) | MoM% Growth | Impact Significance |
| :--- | :--- | :--- | :--- | :--- |
| **Total Loan Applications** | 38,576 | 4,314 | +6.9% | Strong ongoing credit demand[cite: 3] |
| **Total Capital Funded** | $435.76M | $53.98M | +13.0% | Active capital deployment[cite: 3] |
| **Total Repayments Received** | $473.07M | $58.08M | +15.8% | Net interest revenue covering principal[cite: 3] |
| **Average Interest Rate** | 12.04% | 12.36% | +3.5% | Stable portfolio yield[cite: 3] |
| **Average DTI Ratio** | 13.33% | 13.67% | +2.5% | Leverage within conservative thresholds[cite: 3] |

### Risk Segmentation Analysis (Good vs. Bad Loans)
* **Good Loans (Fully Paid / Current):** 33,243 applications (86.18%)[cite: 3] | **+$65.54M** net profit generated[cite: 3].
* **Bad Loans (Charged Off / Default):** 5,333 applications (13.82%)[cite: 3] | **-$28.22M** capital loss write-off exposure[cite: 3].

## Quality Assurance & Verification
Every visual card, matrix line, and slicer result in Power BI was reconciled line-by-line against documented SQL database baseline queries to ensure 100% calculation accuracy prior to reporting[cite: 3].
