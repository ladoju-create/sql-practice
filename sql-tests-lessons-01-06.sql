-- =====================================================================
-- SQL refresher test: SQLBolt lessons 1-6
-- Olamide Adojutelegan
--
-- HOW TO USE
-- 1. Go to sqliteonline.com (no sign-up needed).
-- 2. Copy the whole SETUP section below into the editor and click Run.
--    This creates two small tables of made-up HR data.
-- 3. For each question, write your query under "-- Your answer:",
--    run it, and check the result looks right.
-- 4. Try each question BEFORE looking anything up. If you get stuck,
--    re-read that SQLBolt lesson, then come back.
-- 5. When done, save this file in your sql-practice folder and push:
--      git add .
--      git commit -m "SQL refresher test: lessons 1-6"
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
-- LESSON 1: SELECT queries
-- =====================================================================

-- 1.1 Show every column for every employee.
-- Your answer:
select * from employees;

-- 1.2 Show only each employee's first name, last name and job title.
-- Your answer:
select first_name, last_name, job_title from employees;

-- 1.3 Show the name and location of every department.
-- Your answer:
select dept_name, location from departments;

-- =====================================================================
-- LESSON 2: Queries with constraints (numbers)
-- =====================================================================

-- 2.1 Find employees earning more than 50,000.
-- Your answer:
select * from employees where salary > 50000;

-- 2.2 Find employees in grade 3 or grade 4. Use IN.
-- Your answer:
select * from employees where grade in (3, 4);

-- 2.3 Find employees earning between 40,000 and 60,000 (inclusive).
-- Your answer:
select * from employees where salary >= 40000 and salary <= 60000;

-- 2.4 Find employees who are NOT in department 2.
--     (Check: does Mo Patel appear? Why or why not? Write your guess
--      as a comment. We'll come back to this in lesson 8.
-- he doesn't appear because his dept_id is null)
-- Your answer:
select * from employees where dept_id != 2;

-- =====================================================================
-- LESSON 3: Queries with constraints (text)
-- =====================================================================

-- 3.1 Find employees whose job title is exactly 'Analyst'.
-- Your answer:
select * from employees where job_title = 'Analyst';

-- 3.2 Find employees whose job title contains the word 'Manager'.
-- Your answer:
select * from employees where job_title like '%Manager%';

-- 3.3 Find employees whose last name starts with 'S'.
-- Your answer:
select * from employees where last_name like 'S%';

-- 3.4 Find departments located in London or Manchester.
-- Your answer:
select * from departments where location = 'London' OR location = 'Manchester'; 

-- =====================================================================
-- LESSON 4: Filtering and sorting results
-- =====================================================================

-- 4.1 List each job title once (no duplicates).
-- Your answer:
select distinct job_title from employees;

-- 4.2 List all employees from highest to lowest salary.
-- Your answer:
select * from employees order by salary desc;

-- 4.3 Show only the top 3 earners.
-- Your answer:
select * from employees order by salary desc limit 3;

-- 4.4 Show the 4th, 5th and 6th highest earners. Use LIMIT and OFFSET.
-- Your answer:
select * from employees order by salary desc limit 3 offset 3;

-- 4.5 List employees alphabetically by last name.
-- Your answer:
select * from employees order by last_name asc;

-- =====================================================================
-- LESSON 5: Review (combine everything so far)
-- =====================================================================

-- 5.1 Find employees hired on or after 1 January 2023 who earn less
--     than 45,000. Show the newest hire first.
--     Hint: dates are stored as text like '2023-01-01'.
-- Your answer:
select * from employees where hire_date >= '2023-01-01' and salary < 45000 order by hire_date desc;

-- 5.2 Who is the second-highest paid employee with the exact job
--     title 'Analyst'? Return only that one person.
-- Your answer:
select * from employees where job_title = 'Analyst' order by salary desc limit 1 offset 1;

-- 5.3 List the different grades that exist in department 1, lowest
--     first, with no duplicates.
-- Your answer:
select distinct grade from employees where dept_id = 1 order by grade asc;

-- =====================================================================
-- LESSON 6: Multi-table queries with JOINs
-- =====================================================================

-- 6.1 Show each employee's first name, last name and department name.
-- Your answer:
select first_name, last_name, dept_name from employees inner join departments on employees.dept_id = departments.dept_id;

-- 6.2 Find employees who work in a London-based department.
--     Show their name, department name and location.
-- Your answer:
select first_name, last_name, dept_name, location from employees inner join departments on employees.dept_id = departments.dept_id where location = 'London';

-- 6.3 List everyone in the Finance department, highest salary first.
--     Use the department NAME, not the number 1.
-- Your answer:
select * from employees inner join departments on employees.dept_id = departments.dept_id where dept_name = 'Finance' order by salary desc;

-- 6.4 Think about it (write your answer as a comment, no query needed):
--     There are 15 employees, but how many rows does 6.1 return? 14
--     Which employee is missing, and why? patel, because his dept id is null
--     Is any department missing from the results too? Legal is

-- =====================================================================
-- MY JOINS NOTE (in my own words, without looking anything up):
-- A JOIN combines two tables using a shared column (like dept_id) to match rows.
-- An INNER JOIN only keeps rows that match in both tables, so anything without
-- a match is left out (e.g. Mo with no department, and Legal with no employees).
-- =====================================================================
