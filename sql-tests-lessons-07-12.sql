-- =====================================================================
-- SQL refresher test: SQLBolt lessons 7-12
-- Olamide Adojutelegan
--
-- HOW TO USE
-- 1. Do SQLBolt lessons 7-12 first (sqlbolt.com). Try each exercise
--    before reading the lesson.
-- 2. Go to sqliteonline.com, paste the SETUP section below and click Run.
--    It's the same HR data as last time.
-- 3. Write each answer under "-- Your answer:" (no -- in front of the
--    query, so the file runs top to bottom). Run it and check the result.
-- 4. Written answers go in comments (start each line with --).
-- 5. Save as sql-tests-lessons-07-12.sql in sql-practice and push:
--      git add .
--      git commit -m "SQL refresher test: lessons 7-12"
--      git push
-- =====================================================================


-- =========================== SETUP ===================================

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    dept_id    INTEGER PRIMARY KEY,
    dept_name  TEXT,
    location   TEXT
);

CREATE TABLE employees (
    emp_id      INTEGER PRIMARY KEY,
    first_name  TEXT,
    last_name   TEXT,
    dept_id     INTEGER,
    job_title   TEXT,
    grade       INTEGER,
    salary      INTEGER,
    hire_date   TEXT,
    manager_id  INTEGER
);

INSERT INTO departments VALUES
(1, 'Finance',          'London'),
(2, 'People',           'Manchester'),
(3, 'Data & Analytics', 'London'),
(4, 'Sales',            'Birmingham'),
(5, 'Legal',            'Leeds');

INSERT INTO employees VALUES
(1,  'Amara',  'Okafor',  1,    'Finance Manager', 5, 72000, '2019-03-11', NULL),
(2,  'Ben',    'Hughes',  1,    'Analyst',         3, 41000, '2022-06-01', 1),
(3,  'Chloe',  'Smith',   1,    'Senior Analyst',  4, 52000, '2020-09-14', 1),
(4,  'Daniel', 'Reyes',   2,    'HR Manager',      5, 68000, '2018-01-22', NULL),
(5,  'Ella',   'Shah',    2,    'HR Advisor',      3, 38000, '2023-04-03', 4),
(6,  'Farah',  'Ali',     2,    'Reward Analyst',  3, 43000, '2024-02-19', 4),
(7,  'George', 'Stone',   3,    'Data Engineer',   4, 61000, '2021-11-08', 9),
(8,  'Hannah', 'Price',   3,    'Analyst',         3, 45000, '2023-08-21', 9),
(9,  'Isaac',  'Brown',   3,    'Data Manager',    5, 80000, '2017-05-30', NULL),
(10, 'Jade',   'Simmons', 3,    'BI Developer',    4, 56000, '2022-01-10', 9),
(11, 'Kofi',   'Mensah',  4,    'Sales Executive', 2, 32000, '2024-07-15', 12),
(12, 'Laura',  'Evans',   4,    'Sales Manager',   5, 66000, '2016-10-03', NULL),
(13, 'Mo',     'Patel',   NULL, 'Analyst',         3, 39000, '2025-01-06', NULL),
(14, 'Nina',   'Scott',   1,    'Analyst',         3, 47000, '2021-03-29', 1),
(15, 'Oscar',  'Lee',     4,    'Sales Executive', 2, 34000, '2023-11-13', 12);

-- ========================= END OF SETUP ==============================


-- =====================================================================
-- LESSON 7: OUTER JOINs
-- =====================================================================

-- 7.1 List every employee's first name, last name and department name,
--     INCLUDING employees with no department. (How many rows now?)
-- Your answer:
--15 rows
select emp_id, first_name, last_name, dept_name 
from employees 
left outer join departments on employees.dept_id = departments.dept_id;

-- 7.2 List every department name with the first names of its employees,
--     INCLUDING departments with no employees.
-- Your answer:
select dept_name, first_name 
from departments 
left outer join employees 
on departments.dept_id = employees.dept_id;

-- =====================================================================
-- LESSON 8: NULLs
-- =====================================================================

-- 8.1 Find employees who have no department.
-- Your answer:
select first_name 
from employees 
left outer join departments  on employees.dept_id = departments.dept_id 
where dept_name IS NULL;

-- 8.2 Find employees who DO have a manager.
-- Your answer:
select first_name, manager_id 
from employees 
left outer join departments on employees.dept_id = departments.dept_id 
where manager_id IS not NULL;

-- 8.3 Which departments have no employees at all? Return only the
--     department name. Hint: combine an outer join with 8.1's idea.
-- Your answer:
select dept_name
from departments
left join employees on departments.dept_id = employees.dept_id
where emp_id is null;

-- 8.4 Last time, "WHERE dept_id != 2" left Mo out. Rewrite it so
--     everyone NOT in department 2 is returned, including Mo.
-- Your answer:
select first_name, dept_id 
from employees 
where dept_id != 2 or dept_id is null;

-- =====================================================================
-- LESSON 9: Queries with expressions
-- =====================================================================

-- 9.1 Show each employee's first name and monthly salary
--     (annual salary / 12). Call the column monthly_salary.
--     Bonus: look at Ben's result. Why are the pence missing?
--     Try dividing by 12.0 instead and write what changes as a comment.
-- Your answer:
select first_name, (salary/12.0) AS monthly_salary from employees;
-- without .0, no decimal. this is because without a decimal point, it is considered a whole number division.

-- 9.2 Show each employee's full name as ONE column called full_name.
--     Hint: in SQLite, || joins text together: 'a' || 'b' gives 'ab'.
-- Your answer:
select first_name || ' ' || last_name as full_name from employees;

-- 9.3 Pay review: show each employee's first name, current salary and
--     their salary after a 3% increase, in a column called new_salary.
-- Your answer:
select first_name, salary, (salary * 1.03) as new_salary from employees;

-- =====================================================================
-- LESSON 10: Queries with aggregates (part 1)
-- =====================================================================

-- 10.1 What is the total annual salary bill for all employees?
-- Your answer:
select sum(salary) as total_salary from employees;

-- 10.2 In ONE query, show the average, lowest and highest salary.
--      Give each column a clear name.
-- Your answer:
select avg(salary) as average_salary, 
max(salary) as highest_salary, 
min(salary) as lowest_salary 
from employees;

-- 10.3 Run COUNT(*) and COUNT(dept_id) in one query. Why are the
--      results different? Answer as a comment.
-- Your answer:
select count(*), Count(dept_id) from employees;
--Mo has no dept so he doesn't count.
-- COUNT(*) counts rows; COUNT(column) counts only the non-NULL values in that column.

-- 10.4 Show each dept_id with its number of employees and average
--      salary.
-- Your answer:
select dept_id, count(*) as no_of_employees, avg(salary) as average_salary 
from employees 
group by dept_id;

-- =====================================================================
-- LESSON 11: Queries with aggregates (part 2): HAVING
-- =====================================================================
-- 11.1 Show each department NAME with its average salary,
--      highest average first.
-- Your answer:
select dept_name, avg(salary) as average_salary
from departments 
left join employees on departments.dept_id = employees.dept_id
group by dept_name
order by average_salary desc;

-- 11.2 Same as 11.1, but only departments with more than 3 employees.
-- Your answer:
select dept_name, avg(salary) as average_salary
from departments 
left join employees on departments.dept_id = employees.dept_id
group by dept_name
having count(employees.emp_id) > 3
order by average_salary desc;
-- When you’ve used a LEFT JOIN, count a column from the right-hand table, not *.

-- 11.3 Which job titles are held by more than one person? Show the
--      title and how many people hold it.
-- Your answer:
select job_title, count(*) as people
from employees
group by job_title
having count(*) > 1;

-- =====================================================================
-- LESSON 12: Order of execution
-- =====================================================================

-- 12.1 Put these in the order SQL actually processes them (comment):
--      SELECT, FROM / JOIN, ORDER BY, WHERE, LIMIT, GROUP BY, HAVING
-- Your answer:
-- FROM / JOIN: get the tables
-- WHERE: filter rows
-- GROUP BY: form groups
-- HAVING: filter groups
-- SELECT: pick the columns and calculate them
-- ORDER BY: sort
-- LIMIT: cut down the results

-- 12.2 Why does "WHERE AVG(salary) > 50000" fail, and what should you
--      use instead? Answer as a comment.
-- Your answer:
-- you should use having. where filters before aggregation, so it can't use aggregate functions like AVG. 
-- HAVING filters after aggregation.

-- 12.3 Challenge: for grade 3 employees only, show each department
--      name with its headcount and average salary. Keep only
--      departments where that average is above 41,000.
--      Highest average first.
-- Your answer:
select dept_name, count(*) as headcount, avg(salary) as average_salary
from departments 
left join employees on departments.dept_id = employees.dept_id
where grade = 3
group by dept_name
having avg(salary) > 41000
order by average_salary desc;

-- =====================================================================
-- MY NOTES (in my own words, without looking anything up):
-- LEFT JOIN vs INNER JOIN:
-- WHERE vs HAVING:
-- =====================================================================
