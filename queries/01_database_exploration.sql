USE sql_murder_mystery;

-- ============================================
-- SQL Murder Mystery
-- Portfolio Project
-- Section 1: Database Exploration
-- ============================================

-- Task 1: List all tables in the database
SHOW TABLES;

-- Task 2: Inspect the structure of the person table
DESC person;

-- Task 3: Preview the first 10 person records
SELECT *
FROM person
LIMIT 10;

-- Task 4: Count total people
SELECT COUNT(*) AS total_people
FROM person;

-- Task 5: Find unique street names
SELECT DISTINCT address_street_name
FROM person
ORDER BY address_street_name;

-- Task 6: Count unique street names
SELECT COUNT(DISTINCT address_street_name) AS total_unique_streets
FROM person;

-- Task 7: View selected person columns
SELECT id,
       name,
       address_number,
       address_street_name
FROM person
LIMIT 10;

-- Task 8: Sort people alphabetically
SELECT *
FROM person
ORDER BY name ASC
LIMIT 20;

-- Task 9: Highest address numbers first
SELECT *
FROM person
ORDER BY address_number DESC
LIMIT 20;

-- Task 10: Find people without licence information
SELECT *
FROM person
WHERE license_id IS NULL;

-- Task 11: Count people without licence information
SELECT COUNT(*) AS people_without_license
FROM person
WHERE license_id IS NULL;
