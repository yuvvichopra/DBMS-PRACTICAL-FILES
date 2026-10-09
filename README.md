# DBMS SQL Experiments 3–6

SQL scripts extracted and organized from the four supplied DBMS experiment PDFs.

## Files and run order

1. `01_experiment_3.sql` — creates `EmployeeManagement`, tables, sample data, and selection/projection/aggregate queries.
2. `02_experiment_4.sql` — JOINs, correlated subqueries, EXISTS, simulated INTERSECT/EXCEPT, and EXPLAIN.
3. `03_experiment_5.sql` — views, employee hierarchy, updatability checks, and recursive CTEs.
4. `04_experiment_6.sql` — stored procedure, salary validation triggers, and audit logging.

## How to run

- Use MySQL 8.0+ (recursive CTEs require MySQL 8.0+).
- Run the scripts in numerical order, in the same database connection/server.
- Run Experiment 3 only on a fresh database/schema. It creates tables and inserts fixed sample IDs, so running it repeatedly will produce duplicate-object/key errors.
- Experiment 5 adds `manager_id` and creates views; run it once after Experiment 3.
- Experiment 6 creates a stored procedure and triggers; run it once after Experiment 3. The script's intentionally failing edge-case statements are commented out. Uncomment and run them one at a time if you want to demonstrate the expected errors.
- The hierarchy UPDATE statements in Experiment 5 are kept in the same order/content as the supplied PDF, including repeated department assignments.
