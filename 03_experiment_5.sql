-- EXPERIMENT 5
-- Views, employee hierarchy, view updatability, and recursive CTEs
-- Prerequisite: run 01_experiment_3.sql and 02_experiment_4.sql first.
-- Run this script once on a fresh database. It adds manager_id to Employee.

USE EmployeeManagement;

-- 1. Department salary summary view
CREATE VIEW Department_Salary_Summary AS
SELECT d.dept_id,
       d.dept_name,
       COUNT(e.emp_id) AS total_employees,
       SUM(e.salary) AS total_salary,
       AVG(e.salary) AS average_salary,
       MAX(e.salary) AS highest_salary,
       MIN(e.salary) AS lowest_salary
FROM Department d
LEFT JOIN Employee e ON d.dept_id = e.dept_id
GROUP BY d.dept_id, d.dept_name;

SELECT * FROM Department_Salary_Summary;

-- 2. Departments with average salary greater than 75,000
SELECT dept_name, average_salary
FROM Department_Salary_Summary
WHERE average_salary > 75000;

-- 3. Add manager_id and its self-referencing foreign key
ALTER TABLE Employee ADD manager_id INT NULL;
ALTER TABLE Employee
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (manager_id) REFERENCES Employee(emp_id);

-- 4. Set top-level managers
UPDATE Employee SET manager_id = NULL
WHERE emp_id IN (105, 112, 114, 122, 125);

-- 5. IT hierarchy
UPDATE Employee SET manager_id = 105 WHERE emp_id IN (103, 104);
UPDATE Employee SET manager_id = 103 WHERE emp_id IN (101, 102);
UPDATE Employee SET manager_id = 104 WHERE emp_id = 106;

-- 6. HR hierarchy (as listed in the experiment)
UPDATE Employee SET manager_id = 105 WHERE emp_id IN (103, 104);
UPDATE Employee SET manager_id = 103 WHERE emp_id IN (101, 102);
UPDATE Employee SET manager_id = 104 WHERE emp_id = 106;

-- 7. Finance hierarchy
UPDATE Employee SET manager_id = 112 WHERE emp_id IN (107, 108);
UPDATE Employee SET manager_id = 107 WHERE emp_id = 109;
UPDATE Employee SET manager_id = 108 WHERE emp_id IN (110, 111);

-- 8. Marketing hierarchy (as listed in the experiment)
UPDATE Employee SET manager_id = 112 WHERE emp_id IN (107, 108);
UPDATE Employee SET manager_id = 107 WHERE emp_id = 109;
UPDATE Employee SET manager_id = 108 WHERE emp_id IN (110, 111);

-- 9. Research hierarchy
UPDATE Employee SET manager_id = 125 WHERE emp_id IN (126, 127, 128);
UPDATE Employee SET manager_id = 126 WHERE emp_id = 129;
UPDATE Employee SET manager_id = 128 WHERE emp_id = 130;

-- 10. Employee hierarchy view
CREATE VIEW Employee_Hierarchy AS
SELECT e.emp_id,
       e.emp_name AS employee_name,
       e.manager_id,
       m.emp_name AS manager_name,
       e.salary,
       e.dept_id
FROM Employee e
LEFT JOIN Employee m ON e.manager_id = m.emp_id;

SELECT * FROM Employee_Hierarchy;

-- 11. Simple updatable view
CREATE VIEW Employee_Basic AS
SELECT emp_id, emp_name, salary, dept_id
FROM Employee;

SELECT * FROM Employee_Basic WHERE emp_id = 101;

-- 12. Update through the view and verify in base table
UPDATE Employee_Basic
SET salary = 78000
WHERE emp_id = 101;

SELECT * FROM Employee WHERE emp_id = 101;

-- 13. Expected to fail: aggregate views are generally not updatable.
-- Run separately if you want to observe the error.
-- UPDATE Department_Salary_Summary
-- SET average_salary = 80000
-- WHERE dept_id = 1;

-- 14. Recursive CTE: reporting chain from top-level managers
WITH RECURSIVE EmployeeChain AS (
    SELECT emp_id, emp_name, manager_id,
           0 AS level,
           CAST(emp_name AS CHAR(500)) AS reporting_chain
    FROM Employee
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.emp_id, e.emp_name, e.manager_id,
           ec.level + 1,
           CONCAT(ec.reporting_chain, ' -> ', e.emp_name)
    FROM Employee e
    INNER JOIN EmployeeChain ec ON e.manager_id = ec.emp_id
)
SELECT emp_id, emp_name, manager_id, level, reporting_chain
FROM EmployeeChain
ORDER BY reporting_chain;

-- 15. Recursive CTE: selected employee and their managers
WITH RECURSIVE ReportingChain AS (
    SELECT emp_id, emp_name, manager_id, 0 AS level
    FROM Employee
    WHERE emp_id = 101

    UNION ALL

    SELECT e.emp_id, e.emp_name, e.manager_id, rc.level + 1
    FROM Employee e
    JOIN ReportingChain rc ON e.emp_id = rc.manager_id
)
SELECT emp_id, emp_name, manager_id, level
FROM ReportingChain;
