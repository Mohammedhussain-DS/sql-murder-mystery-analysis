# SQL Murder Mystery Analysis

A MySQL portfolio project that uses a fictional crime database to demonstrate SQL investigation, relational querying, and analytical thinking.

## Project Overview

The project starts with a murder report in SQL City and follows the evidence across multiple related tables. The investigation identifies witnesses, analyses interview transcripts, connects gym and vehicle records, and ultimately traces the crime to the person who organised it.

I then extend the original mystery with additional exploratory and analytical questions so the repository demonstrates more than simply completing the game.

> **Spoiler warning:** some SQL files reveal the solution to the mystery.

## Tools

- MySQL
- MySQL Workbench
- GitHub

## Dataset

The database contains 9 tables used in the investigation:

- `crime_scene_report`
- `person`
- `drivers_license`
- `interview`
- `get_fit_now_member`
- `get_fit_now_check_in`
- `facebook_event_checkin`
- `income`
- `solution`

The source dataset is the SQL Murder Mystery dataset, imported into MySQL Workbench for this project.

## SQL Skills Demonstrated

- `SELECT`, `WHERE`, `AND`, `OR`, `LIKE`, `IN`, `BETWEEN`
- `DISTINCT`, `ORDER BY`, `LIMIT`
- `COUNT`, `AVG`, `MIN`, `MAX`, `SUM`
- `GROUP BY` and `HAVING`
- `INNER JOIN`, `LEFT JOIN`, and multiple-table joins
- Subqueries
- Common Table Expressions (`WITH`)
- `CASE`
- Window functions
- `ROW_NUMBER`, `RANK`, `DENSE_RANK`
- `PARTITION BY`
- `LAG` and running totals
- Date conversion and date analysis

## Repository Structure

```text
sql-murder-mystery-analysis/
├── README.md
└── queries/
    ├── 01_database_exploration.sql
    ├── 02_crime_scene_analysis.sql
    ├── 03_witness_investigation.sql
    ├── 04_suspect_investigation.sql
    ├── 05_mastermind_investigation.sql
    ├── 06_advanced_sql_analysis.sql
    ├── 07_final_project_summary.sql
    └── 08_original_data_analysis.sql
```

## Investigation Workflow

1. Explore the database structure and row counts.
2. Locate the relevant murder report.
3. Extract witness clues from the report.
4. Identify witnesses using address and name information.
5. Join witness records to interview transcripts.
6. Use gym membership and check-in evidence to narrow suspects.
7. Join suspect data to driver's licence records.
8. Analyse the suspect interview for the next set of clues.
9. Use demographic, vehicle, event-attendance, and income data to identify the mastermind.
10. Extend the project with independent analytical questions.

## Investigation Result

The evidence identifies **Jeremy Bowers** as the murderer and **Miranda Priestly** as the person who hired him.

The conclusion is based on evidence across several independent tables rather than a single lookup.

## Additional Analysis

The final section goes beyond the mystery and asks analyst-style questions such as:

- Which cities have the most crime reports?
- Which crime types are most common?
- What percentage of reports belongs to each crime category?
- Which age groups have the highest average income?
- What is the average income by gender?
- Which vehicle manufacturers are most common?
- Who are the most active gym members?
- Which events receive the most check-ins?
- Who are the top income earners within each gender?

## Why I Built This Project

The objective was to practise SQL in a way that demonstrates problem solving rather than isolated syntax. Each stage uses evidence from one query to determine the next question, which is similar to how analysts explore relational datasets in real work.

## Author

**Mohammedhussain-DS**

Data analytics portfolio project using MySQL.