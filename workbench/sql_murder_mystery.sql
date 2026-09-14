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


-- Task 3: Preview the first 10 records from the person table
SELECT *
FROM person
LIMIT 10;


-- Task 4: Count the total number of people
SELECT COUNT(*) AS total_people
FROM person;


-- Task 5: Find all unique street names
SELECT DISTINCT address_street_name
FROM person;


-- Task 6: Count the number of unique street names
SELECT COUNT(DISTINCT address_street_name) AS total_unique_streets
FROM person;


-- Task 7: View selected columns from the person table
SELECT id,
       name,
       address_number,
       address_street_name
FROM person
LIMIT 10;


-- Task 8: Sort people alphabetically by name
SELECT *
FROM person
ORDER BY name ASC
LIMIT 20;


-- Task 9: Sort people by address number from highest to lowest
SELECT *
FROM person
ORDER BY address_number DESC
LIMIT 20;


-- Task 10: Find people with missing licence information
SELECT *
FROM person
WHERE license_id IS NULL;


-- Task 11: Count people with missing licence information
SELECT COUNT(*) AS people_without_license
FROM person
WHERE license_id IS NULL;


-- ============================================
-- End of Section 1: Database Exploration
-- ============================================



-- ============================================
-- SQL Murder Mystery
-- Portfolio Project
-- Section 2: Crime Scene Analysis
-- ============================================


-- Task 1: Inspect the structure of the crime_scene_report table
DESC crime_scene_report;


-- Task 2: Preview the first 10 crime reports
SELECT *
FROM crime_scene_report
LIMIT 10;


-- Task 3: Count the total number of crime reports
SELECT COUNT(*) AS total_crime_reports
FROM crime_scene_report;


-- Task 4: Find all unique crime types
SELECT DISTINCT type
FROM crime_scene_report
ORDER BY type;


-- Task 5: Count reports for each crime type
SELECT
    type,
    COUNT(*) AS total_reports
FROM crime_scene_report
GROUP BY type
ORDER BY total_reports DESC;


-- Task 6: Find all crime reports from SQL City
SELECT *
FROM crime_scene_report
WHERE city = 'SQL City';


-- Task 7: Find murder reports from SQL City
SELECT *
FROM crime_scene_report
WHERE city = 'SQL City'
AND type = 'murder';


-- Task 8: Sort SQL City murder reports by date
SELECT
    date,
    type,
    description,
    city
FROM crime_scene_report
WHERE city = 'SQL City'
AND type = 'murder'
ORDER BY date ASC;


-- Task 9: Find murder reports during January 2018
SELECT *
FROM crime_scene_report
WHERE type = 'murder'
AND date BETWEEN 20180101 AND 20180131
ORDER BY date;


-- Task 10: Find January 2018 murder reports specifically in SQL City
SELECT
    date,
    type,
    description,
    city
FROM crime_scene_report
WHERE city = 'SQL City'
AND type = 'murder'
AND date BETWEEN 20180101 AND 20180131
ORDER BY date;


-- Task 11: Search crime descriptions containing the word 'witness'
SELECT *
FROM crime_scene_report
WHERE description LIKE '%witness%';


-- Task 12: Search SQL City murder reports containing witness information
SELECT
    date,
    description
FROM crime_scene_report
WHERE city = 'SQL City'
AND type = 'murder'
AND description LIKE '%witness%';


-- Task 13: Count crime reports by city
SELECT
    city,
    COUNT(*) AS total_crimes
FROM crime_scene_report
GROUP BY city
ORDER BY total_crimes DESC;


-- Task 14: Find the 10 cities with the most crime reports
SELECT
    city,
    COUNT(*) AS total_crimes
FROM crime_scene_report
GROUP BY city
ORDER BY total_crimes DESC
LIMIT 10;


-- Task 15: Count murders by city
SELECT
    city,
    COUNT(*) AS total_murders
FROM crime_scene_report
WHERE type = 'murder'
GROUP BY city
ORDER BY total_murders DESC;


-- ============================================
-- End of Section 2: Crime Scene Analysis
-- ============================================

-- ============================================
-- SQL Murder Mystery
-- Portfolio Project
-- Section 3: Witness Investigation
-- ============================================


-- Task 1:
-- Find everyone who lives on Northwestern Dr
SELECT
    id,
    name,
    address_number,
    address_street_name
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC;


-- Task 2:
-- Identify the first witness:
-- The crime report states that the witness lives
-- at the LAST house on Northwestern Dr
SELECT
    id,
    name,
    address_number,
    address_street_name
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;


-- Task 3:
-- Find people named Annabel
SELECT
    id,
    name,
    address_number,
    address_street_name
FROM person
WHERE name LIKE 'Annabel%';


-- Task 4:
-- Identify the second witness:
-- Annabel lives somewhere on Franklin Ave
SELECT
    id,
    name,
    address_number,
    address_street_name
FROM person
WHERE name LIKE 'Annabel%'
AND address_street_name = 'Franklin Ave';


-- Task 5:
-- Inspect the structure of the interview table
DESC interview;


-- Task 6:
-- Preview interview records
SELECT *
FROM interview
LIMIT 10;


-- Task 7:
-- Retrieve the first witness interview
SELECT
    p.id,
    p.name,
    i.transcript
FROM person AS p
INNER JOIN interview AS i
    ON p.id = i.person_id
WHERE p.address_street_name = 'Northwestern Dr'
ORDER BY p.address_number DESC
LIMIT 1;


-- Task 8:
-- Retrieve the second witness interview
SELECT
    p.id,
    p.name,
    i.transcript
FROM person AS p
INNER JOIN interview AS i
    ON p.id = i.person_id
WHERE p.name LIKE 'Annabel%'
AND p.address_street_name = 'Franklin Ave';


-- Task 9:
-- Retrieve both known witness interviews together
SELECT
    p.id,
    p.name,
    p.address_number,
    p.address_street_name,
    i.transcript
FROM person AS p
INNER JOIN interview AS i
    ON p.id = i.person_id
WHERE p.id IN (14887, 16371);


-- Task 10:
-- Demonstrate the first witness search using a subquery
SELECT
    p.name,
    i.transcript
FROM person AS p
INNER JOIN interview AS i
    ON p.id = i.person_id
WHERE p.id = (
    SELECT id
    FROM person
    WHERE address_street_name = 'Northwestern Dr'
    ORDER BY address_number DESC
    LIMIT 1
);


-- Task 11:
-- Demonstrate the second witness search using a subquery
SELECT
    p.name,
    i.transcript
FROM person AS p
INNER JOIN interview AS i
    ON p.id = i.person_id
WHERE p.id = (
    SELECT id
    FROM person
    WHERE name LIKE 'Annabel%'
    AND address_street_name = 'Franklin Ave'
    LIMIT 1
);


-- ============================================
-- Key Investigation Findings
-- ============================================

-- Witness 1:
-- Morty Schapiro
-- Lives at the highest address number on Northwestern Dr.

-- Witness 2:
-- Annabel Miller
-- Lives on Franklin Ave.

-- The witness statements provide new clues involving:
-- 1. Get Fit Now Gym
-- 2. A gold membership
-- 3. A membership ID beginning with 48Z
-- 4. A vehicle plate containing H42W
-- 5. A gym visit on January 9, 2018


-- ============================================
-- End of Section 3: Witness Investigation
-- ============================================


-- ============================================
-- SQL Murder Mystery
-- Portfolio Project
-- Section 4: Suspect Investigation
-- ============================================


-- ============================================
-- Task 1: Inspect the gym membership table
-- ============================================

DESC get_fit_now_member;


-- ============================================
-- Task 2: Preview gym membership records
-- ============================================

SELECT *
FROM get_fit_now_member
LIMIT 10;


-- ============================================
-- Task 3: Inspect the gym check-in table
-- ============================================

DESC get_fit_now_check_in;


-- ============================================
-- Task 4: Preview gym check-in records
-- ============================================

SELECT *
FROM get_fit_now_check_in
LIMIT 10;


-- ============================================
-- Task 5:
-- Find gym memberships beginning with 48Z
-- Witness clue: Membership ID starts with 48Z
-- ============================================

SELECT *
FROM get_fit_now_member
WHERE id LIKE '48Z%';


-- ============================================
-- Task 6:
-- Find 48Z members with GOLD membership
-- ============================================

SELECT
    id,
    person_id,
    name,
    membership_status
FROM get_fit_now_member
WHERE id LIKE '48Z%'
AND membership_status = 'gold';


-- ============================================
-- Task 7:
-- Find gym check-ins on January 9, 2018
-- ============================================

SELECT *
FROM get_fit_now_check_in
WHERE check_in_date = 20180109;


-- ============================================
-- Task 8:
-- Combine membership clue + check-in date
-- ============================================

SELECT
    m.id AS membership_id,
    m.person_id,
    m.name,
    m.membership_status,
    c.check_in_date,
    c.check_in_time,
    c.check_out_time
FROM get_fit_now_member AS m
INNER JOIN get_fit_now_check_in AS c
    ON m.id = c.membership_id
WHERE m.id LIKE '48Z%'
AND m.membership_status = 'gold'
AND c.check_in_date = 20180109;


-- ============================================
-- Task 9:
-- Connect matching gym members to person records
-- ============================================

SELECT
    p.id AS person_id,
    p.name,
    p.license_id,
    m.id AS membership_id,
    m.membership_status,
    c.check_in_date,
    c.check_in_time,
    c.check_out_time
FROM person AS p
INNER JOIN get_fit_now_member AS m
    ON p.id = m.person_id
INNER JOIN get_fit_now_check_in AS c
    ON m.id = c.membership_id
WHERE m.id LIKE '48Z%'
AND m.membership_status = 'gold'
AND c.check_in_date = 20180109;


-- ============================================
-- Task 10:
-- Find driver's licences containing H42W
-- Witness clue: Vehicle plate contained H42W
-- ============================================

SELECT
    id,
    gender,
    plate_number,
    car_make,
    car_model
FROM drivers_license
WHERE plate_number LIKE '%H42W%';


-- ============================================
-- Task 11:
-- Connect people with licence plates containing H42W
-- ============================================

SELECT
    p.id AS person_id,
    p.name,
    d.gender,
    d.plate_number,
    d.car_make,
    d.car_model
FROM person AS p
INNER JOIN drivers_license AS d
    ON p.license_id = d.id
WHERE d.plate_number LIKE '%H42W%';


-- ============================================
-- Task 12:
-- Combine ALL witness clues
-- ============================================

SELECT
    p.id AS person_id,
    p.name,
    m.id AS membership_id,
    m.membership_status,
    c.check_in_date,
    c.check_in_time,
    c.check_out_time,
    d.gender,
    d.plate_number,
    d.car_make,
    d.car_model
FROM person AS p
INNER JOIN get_fit_now_member AS m
    ON p.id = m.person_id
INNER JOIN get_fit_now_check_in AS c
    ON m.id = c.membership_id
INNER JOIN drivers_license AS d
    ON p.license_id = d.id
WHERE m.id LIKE '48Z%'
AND m.membership_status = 'gold'
AND c.check_in_date = 20180109
AND d.plate_number LIKE '%H42W%';


-- ============================================
-- Task 13:
-- Confirm whether the suspect has an interview
-- ============================================

SELECT
    p.name,
    i.transcript
FROM person AS p
INNER JOIN interview AS i
    ON p.id = i.person_id
INNER JOIN get_fit_now_member AS m
    ON p.id = m.person_id
INNER JOIN get_fit_now_check_in AS c
    ON m.id = c.membership_id
INNER JOIN drivers_license AS d
    ON p.license_id = d.id
WHERE m.id LIKE '48Z%'
AND m.membership_status = 'gold'
AND c.check_in_date = 20180109
AND d.plate_number LIKE '%H42W%';


-- ============================================
-- Task 14: Advanced Version Using a CTE
-- ============================================

WITH gym_suspects AS (
    SELECT
        m.person_id,
        m.id AS membership_id,
        m.membership_status,
        c.check_in_date
    FROM get_fit_now_member AS m
    INNER JOIN get_fit_now_check_in AS c
        ON m.id = c.membership_id
    WHERE m.id LIKE '48Z%'
    AND m.membership_status = 'gold'
    AND c.check_in_date = 20180109
)
SELECT
    p.id AS person_id,
    p.name,
    gs.membership_id,
    d.gender,
    d.plate_number,
    d.car_make,
    d.car_model
FROM gym_suspects AS gs
INNER JOIN person AS p
    ON gs.person_id = p.id
INNER JOIN drivers_license AS d
    ON p.license_id = d.id
WHERE d.plate_number LIKE '%H42W%';


-- ============================================
-- End of Section 4: Suspect Investigation
-- ============================================


-- ============================================
-- SQL Murder Mystery
-- Portfolio Project
-- Section 5: Mastermind Investigation
-- ============================================

-- The remaining Workbench script continues with the mastermind investigation,
-- advanced analysis, final summary, and original analytical questions.
-- The complete recruiter-facing versions of those sections are preserved in
-- queries/05_mastermind_investigation.sql through queries/08_original_data_analysis.sql.
