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
--
-- Clues:
-- 1. Membership starts with 48Z
-- 2. Gold membership
-- 3. Checked into gym on January 9, 2018
-- 4. Vehicle plate contains H42W
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
-- SQL Skills Demonstrated
-- ============================================

-- LIKE
-- AND
-- INNER JOIN
-- Multiple-table JOINs
-- Table aliases
-- Column aliases
-- Filtering across related tables
-- Common Table Expressions (CTE)
-- WITH


-- ============================================
-- End of Section 4: Suspect Investigation
-- ============================================



-- ============================================
-- SQL Murder Mystery
-- Portfolio Project
-- Section 5: Mastermind Investigation
-- ============================================


-- ============================================
-- Investigation Clues from the Killer's Interview
-- ============================================

-- The person who hired the killer:
-- 1. Is a woman
-- 2. Has red hair
-- 3. Is between 65 and 67 inches tall
-- 4. Drives a Tesla Model S
-- 5. Attended the SQL Symphony Concert
--    exactly 3 times in December 2017
-- 6. Has a high income


-- ============================================
-- Task 1:
-- Inspect the Facebook event check-in table
-- ============================================

DESC facebook_event_checkin;


-- ============================================
-- Task 2:
-- Preview event check-in records
-- ============================================

SELECT *
FROM facebook_event_checkin
LIMIT 10;


-- ============================================
-- Task 3:
-- Find women with red hair
-- ============================================

SELECT
    p.id,
    p.name,
    d.height,
    d.hair_color,
    d.gender
FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

WHERE d.gender = 'female'
AND d.hair_color = 'red';


-- ============================================
-- Task 4:
-- Narrow candidates to height between
-- 65 and 67 inches
-- ============================================

SELECT
    p.id,
    p.name,
    d.height,
    d.hair_color,
    d.gender
FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

WHERE d.gender = 'female'
AND d.hair_color = 'red'
AND d.height BETWEEN 65 AND 67;


-- ============================================
-- Task 5:
-- Add vehicle clue:
-- Tesla Model S
-- ============================================

SELECT
    p.id,
    p.name,
    d.height,
    d.hair_color,
    d.gender,
    d.plate_number,
    d.car_make,
    d.car_model
FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

WHERE d.gender = 'female'
AND d.hair_color = 'red'
AND d.height BETWEEN 65 AND 67
AND d.car_make = 'Tesla'
AND d.car_model = 'Model S';


-- ============================================
-- Task 6:
-- Find all SQL Symphony Concert check-ins
-- during December 2017
-- ============================================

SELECT *
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
AND date BETWEEN 20171201 AND 20171231
ORDER BY person_id, date;


-- ============================================
-- Task 7:
-- Count how many times each person attended
-- the SQL Symphony Concert in December 2017
-- ============================================

SELECT
    person_id,
    COUNT(*) AS concert_visits
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
AND date BETWEEN 20171201 AND 20171231
GROUP BY person_id
ORDER BY concert_visits DESC;


-- ============================================
-- Task 8:
-- Find people who attended exactly 3 times
-- ============================================

SELECT
    person_id,
    COUNT(*) AS concert_visits
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
AND date BETWEEN 20171201 AND 20171231
GROUP BY person_id
HAVING COUNT(*) = 3;


-- ============================================
-- Task 9:
-- Add person names to the concert results
-- ============================================

SELECT
    p.id AS person_id,
    p.name,
    COUNT(*) AS concert_visits
FROM person AS p

INNER JOIN facebook_event_checkin AS f
    ON p.id = f.person_id

WHERE f.event_name = 'SQL Symphony Concert'
AND f.date BETWEEN 20171201 AND 20171231

GROUP BY
    p.id,
    p.name

HAVING COUNT(*) = 3;


-- ============================================
-- Task 10:
-- Combine ALL mastermind clues
-- ============================================

SELECT
    p.id AS person_id,
    p.name,
    d.height,
    d.hair_color,
    d.gender,
    d.plate_number,
    d.car_make,
    d.car_model,
    COUNT(f.person_id) AS concert_visits

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

INNER JOIN facebook_event_checkin AS f
    ON p.id = f.person_id

WHERE d.gender = 'female'
AND d.hair_color = 'red'
AND d.height BETWEEN 65 AND 67
AND d.car_make = 'Tesla'
AND d.car_model = 'Model S'
AND f.event_name = 'SQL Symphony Concert'
AND f.date BETWEEN 20171201 AND 20171231

GROUP BY
    p.id,
    p.name,
    d.height,
    d.hair_color,
    d.gender,
    d.plate_number,
    d.car_make,
    d.car_model

HAVING COUNT(f.person_id) = 3;


-- ============================================
-- Task 11:
-- Inspect the income table
-- ============================================

DESC income;


-- ============================================
-- Task 12:
-- Preview income data
-- ============================================

SELECT *
FROM income
ORDER BY annual_income DESC
LIMIT 10;


-- ============================================
-- Task 13:
-- Add income information to the mastermind
-- investigation
-- ============================================

SELECT
    p.id AS person_id,
    p.name,
    d.height,
    d.hair_color,
    d.gender,
    d.car_make,
    d.car_model,
    i.annual_income,
    COUNT(f.person_id) AS concert_visits

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

INNER JOIN facebook_event_checkin AS f
    ON p.id = f.person_id

INNER JOIN income AS i
    ON p.ssn = i.ssn

WHERE d.gender = 'female'
AND d.hair_color = 'red'
AND d.height BETWEEN 65 AND 67
AND d.car_make = 'Tesla'
AND d.car_model = 'Model S'
AND f.event_name = 'SQL Symphony Concert'
AND f.date BETWEEN 20171201 AND 20171231

GROUP BY
    p.id,
    p.name,
    d.height,
    d.hair_color,
    d.gender,
    d.car_make,
    d.car_model,
    i.annual_income

HAVING COUNT(f.person_id) = 3

ORDER BY i.annual_income DESC;


-- ============================================
-- Task 14:
-- Advanced Version Using a CTE
-- ============================================

WITH concert_attendance AS (

    SELECT
        person_id,
        COUNT(*) AS concert_visits

    FROM facebook_event_checkin

    WHERE event_name = 'SQL Symphony Concert'
    AND date BETWEEN 20171201 AND 20171231

    GROUP BY person_id

    HAVING COUNT(*) = 3
)

SELECT
    p.id AS person_id,
    p.name,
    d.height,
    d.hair_color,
    d.gender,
    d.car_make,
    d.car_model,
    i.annual_income,
    ca.concert_visits

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

INNER JOIN concert_attendance AS ca
    ON p.id = ca.person_id

INNER JOIN income AS i
    ON p.ssn = i.ssn

WHERE d.gender = 'female'
AND d.hair_color = 'red'
AND d.height BETWEEN 65 AND 67
AND d.car_make = 'Tesla'
AND d.car_model = 'Model S';


-- ============================================
-- Task 15:
-- Final investigation result
-- ============================================

-- The evidence identifies:
-- Miranda Priestly
--
-- Matching evidence:
-- Female
-- Red hair
-- Height: 66 inches
-- Tesla Model S
-- Attended SQL Symphony Concert 3 times
-- in December 2017
-- Annual income: 310000


-- ============================================
-- SQL Skills Demonstrated
-- ============================================

-- INNER JOIN
-- Multiple-table JOIN
-- BETWEEN
-- COUNT()
-- GROUP BY
-- HAVING
-- ORDER BY
-- Aliases
-- Aggregate filtering
-- CTE / WITH
-- Multi-condition investigation


-- ============================================
-- End of Section 5: Mastermind Investigation
-- ============================================


-- ============================================
-- SQL Murder Mystery
-- Portfolio Project
-- Section 6: Advanced SQL Analysis
-- ============================================


-- ============================================
-- Task 1:
-- Categorise people into age groups using CASE
-- ============================================

SELECT
    p.name,
    d.age,

    CASE
        WHEN d.age < 20 THEN 'Under 20'
        WHEN d.age BETWEEN 20 AND 39 THEN '20-39'
        WHEN d.age BETWEEN 40 AND 59 THEN '40-59'
        ELSE '60+'
    END AS age_group

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

LIMIT 50;


-- ============================================
-- Task 2:
-- Count people in each age group
-- ============================================

SELECT
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 39 THEN '20-39'
        WHEN age BETWEEN 40 AND 59 THEN '40-59'
        ELSE '60+'
    END AS age_group,

    COUNT(*) AS total_people

FROM drivers_license

GROUP BY
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 39 THEN '20-39'
        WHEN age BETWEEN 40 AND 59 THEN '40-59'
        ELSE '60+'
    END

ORDER BY total_people DESC;


-- ============================================
-- Task 3:
-- Categorise people by income level
-- ============================================

SELECT
    p.name,
    i.annual_income,

    CASE
        WHEN i.annual_income >= 200000 THEN 'Very High Income'
        WHEN i.annual_income >= 100000 THEN 'High Income'
        WHEN i.annual_income >= 50000 THEN 'Medium Income'
        ELSE 'Lower Income'
    END AS income_category

FROM person AS p

INNER JOIN income AS i
    ON p.ssn = i.ssn

ORDER BY i.annual_income DESC

LIMIT 50;


-- ============================================
-- Task 4:
-- Calculate average income
-- ============================================

SELECT
    ROUND(AVG(annual_income), 2) AS average_income
FROM income;


-- ============================================
-- Task 5:
-- Find people earning above the average income
-- Using a SUBQUERY
-- ============================================

SELECT
    p.name,
    i.annual_income

FROM person AS p

INNER JOIN income AS i
    ON p.ssn = i.ssn

WHERE i.annual_income > (

    SELECT AVG(annual_income)
    FROM income

)

ORDER BY i.annual_income DESC;


-- ============================================
-- Task 6:
-- Find people earning below the average income
-- ============================================

SELECT
    p.name,
    i.annual_income

FROM person AS p

INNER JOIN income AS i
    ON p.ssn = i.ssn

WHERE i.annual_income < (

    SELECT AVG(annual_income)
    FROM income

)

ORDER BY i.annual_income DESC;


-- ============================================
-- Task 7:
-- Rank everyone by annual income
-- Using ROW_NUMBER()
-- ============================================

SELECT
    p.name,
    i.annual_income,

    ROW_NUMBER() OVER (
        ORDER BY i.annual_income DESC
    ) AS income_row_number

FROM person AS p

INNER JOIN income AS i
    ON p.ssn = i.ssn;


-- ============================================
-- Task 8:
-- Compare ROW_NUMBER, RANK and DENSE_RANK
-- ============================================

SELECT
    p.name,
    i.annual_income,

    ROW_NUMBER() OVER (
        ORDER BY i.annual_income DESC
    ) AS row_number_rank,

    RANK() OVER (
        ORDER BY i.annual_income DESC
    ) AS normal_rank,

    DENSE_RANK() OVER (
        ORDER BY i.annual_income DESC
    ) AS dense_rank

FROM person AS p

INNER JOIN income AS i
    ON p.ssn = i.ssn

LIMIT 50;


-- ============================================
-- Task 9:
-- Rank income separately within each gender
-- PARTITION BY
-- ============================================

SELECT
    p.name,
    d.gender,
    i.annual_income,

    RANK() OVER (
        PARTITION BY d.gender
        ORDER BY i.annual_income DESC
    ) AS income_rank_within_gender

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

INNER JOIN income AS i
    ON p.ssn = i.ssn

ORDER BY
    d.gender,
    income_rank_within_gender;


-- ============================================
-- Task 10:
-- Find the top 3 earners in each gender
-- Using CTE + ROW_NUMBER
-- ============================================

WITH ranked_income AS (

    SELECT
        p.name,
        d.gender,
        i.annual_income,

        ROW_NUMBER() OVER (
            PARTITION BY d.gender
            ORDER BY i.annual_income DESC
        ) AS income_rank

    FROM person AS p

    INNER JOIN drivers_license AS d
        ON p.license_id = d.id

    INNER JOIN income AS i
        ON p.ssn = i.ssn
)

SELECT
    name,
    gender,
    annual_income,
    income_rank

FROM ranked_income

WHERE income_rank <= 3

ORDER BY
    gender,
    income_rank;


-- ============================================
-- Task 11:
-- Find the most common car manufacturers
-- ============================================

SELECT
    car_make,
    COUNT(*) AS total_cars

FROM drivers_license

WHERE car_make IS NOT NULL

GROUP BY car_make

ORDER BY total_cars DESC

LIMIT 10;


-- ============================================
-- Task 12:
-- Rank car manufacturers by popularity
-- ============================================

WITH car_counts AS (

    SELECT
        car_make,
        COUNT(*) AS total_cars

    FROM drivers_license

    WHERE car_make IS NOT NULL

    GROUP BY car_make
)

SELECT
    car_make,
    total_cars,

    DENSE_RANK() OVER (
        ORDER BY total_cars DESC
    ) AS popularity_rank

FROM car_counts

ORDER BY popularity_rank;


-- ============================================
-- Task 13:
-- Find the most active gym members
-- ============================================

SELECT
    m.id AS membership_id,
    m.name,
    COUNT(*) AS total_check_ins

FROM get_fit_now_member AS m

INNER JOIN get_fit_now_check_in AS c
    ON m.id = c.membership_id

GROUP BY
    m.id,
    m.name

ORDER BY total_check_ins DESC

LIMIT 20;


-- ============================================
-- Task 14:
-- Rank gym members by number of visits
-- Using CTE + RANK
-- ============================================

WITH gym_visits AS (

    SELECT
        m.id AS membership_id,
        m.name,
        COUNT(*) AS total_visits

    FROM get_fit_now_member AS m

    INNER JOIN get_fit_now_check_in AS c
        ON m.id = c.membership_id

    GROUP BY
        m.id,
        m.name
)

SELECT
    membership_id,
    name,
    total_visits,

    RANK() OVER (
        ORDER BY total_visits DESC
    ) AS visit_rank

FROM gym_visits

ORDER BY visit_rank;


-- ============================================
-- Task 15:
-- Find the most frequently attended events
-- ============================================

SELECT
    event_name,
    COUNT(*) AS total_check_ins

FROM facebook_event_checkin

GROUP BY event_name

ORDER BY total_check_ins DESC

LIMIT 20;


-- ============================================
-- Task 16:
-- Rank events by total attendance
-- ============================================

WITH event_attendance AS (

    SELECT
        event_name,
        COUNT(*) AS total_attendance

    FROM facebook_event_checkin

    GROUP BY event_name
)

SELECT
    event_name,
    total_attendance,

    DENSE_RANK() OVER (
        ORDER BY total_attendance DESC
    ) AS event_rank

FROM event_attendance

ORDER BY event_rank

LIMIT 20;


-- ============================================
-- Task 17:
-- Calculate percentage of crime reports
-- represented by each crime type
-- ============================================

SELECT
    type,
    COUNT(*) AS total_crimes,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_total

FROM crime_scene_report

GROUP BY type

ORDER BY total_crimes DESC;


-- ============================================
-- Task 18:
-- Convert integer crime dates into real dates
-- ============================================

SELECT
    date AS original_date,

    STR_TO_DATE(
        CAST(date AS CHAR),
        '%Y%m%d'
    ) AS formatted_date,

    type,
    city

FROM crime_scene_report

LIMIT 20;


-- ============================================
-- Task 19:
-- Compare each crime date with the previous
-- crime report using LAG()
-- ============================================

SELECT
    city,

    STR_TO_DATE(
        CAST(date AS CHAR),
        '%Y%m%d'
    ) AS crime_date,

    type,

    LAG(
        STR_TO_DATE(
            CAST(date AS CHAR),
            '%Y%m%d'
        )
    ) OVER (
        PARTITION BY city
        ORDER BY date
    ) AS previous_crime_date

FROM crime_scene_report

ORDER BY
    city,
    date;


-- ============================================
-- Task 20:
-- Calculate number of days between crimes
-- in each city
-- ============================================

WITH crime_dates AS (

    SELECT
        city,
        type,

        STR_TO_DATE(
            CAST(date AS CHAR),
            '%Y%m%d'
        ) AS crime_date,

        LAG(
            STR_TO_DATE(
                CAST(date AS CHAR),
                '%Y%m%d'
            )
        ) OVER (
            PARTITION BY city
            ORDER BY date
        ) AS previous_crime_date

    FROM crime_scene_report
)

SELECT
    city,
    crime_date,
    previous_crime_date,
    type,

    DATEDIFF(
        crime_date,
        previous_crime_date
    ) AS days_since_previous_crime

FROM crime_dates

WHERE previous_crime_date IS NOT NULL

ORDER BY
    city,
    crime_date;


-- ============================================
-- Task 21:
-- Count event check-ins by date
-- ============================================

SELECT
    date,
    COUNT(*) AS daily_check_ins

FROM facebook_event_checkin

GROUP BY date

ORDER BY date;


-- ============================================
-- Task 22:
-- Calculate running total of event check-ins
-- ============================================

WITH daily_events AS (

    SELECT
        date,
        COUNT(*) AS daily_check_ins

    FROM facebook_event_checkin

    GROUP BY date
)

SELECT
    date,
    daily_check_ins,

    SUM(daily_check_ins) OVER (
        ORDER BY date
    ) AS running_total

FROM daily_events

ORDER BY date;


-- ============================================
-- Task 23:
-- Find average income by gender
-- ============================================

SELECT
    d.gender,

    ROUND(
        AVG(i.annual_income),
        2
    ) AS average_income,

    COUNT(*) AS total_people

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

INNER JOIN income AS i
    ON p.ssn = i.ssn

GROUP BY d.gender

ORDER BY average_income DESC;


-- ============================================
-- Task 24:
-- Compare each person's income with the
-- average income of their gender
-- ============================================

SELECT
    p.name,
    d.gender,
    i.annual_income,

    ROUND(
        AVG(i.annual_income) OVER (
            PARTITION BY d.gender
        ),
        2
    ) AS gender_average_income

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

INNER JOIN income AS i
    ON p.ssn = i.ssn

ORDER BY
    d.gender,
    i.annual_income DESC;


-- ============================================
-- Task 25:
-- Show whether income is above or below
-- the person's gender average
-- ============================================

WITH income_comparison AS (

    SELECT
        p.name,
        d.gender,
        i.annual_income,

        AVG(i.annual_income) OVER (
            PARTITION BY d.gender
        ) AS gender_average_income

    FROM person AS p

    INNER JOIN drivers_license AS d
        ON p.license_id = d.id

    INNER JOIN income AS i
        ON p.ssn = i.ssn
)

SELECT
    name,
    gender,
    annual_income,

    ROUND(
        gender_average_income,
        2
    ) AS gender_average_income,

    CASE

        WHEN annual_income > gender_average_income
            THEN 'Above Average'

        WHEN annual_income < gender_average_income
            THEN 'Below Average'

        ELSE 'Average'

    END AS income_position

FROM income_comparison

ORDER BY annual_income DESC;


-- ============================================
-- SQL Skills Demonstrated
-- ============================================

-- CASE
-- COUNT()
-- AVG()
-- ROUND()
-- GROUP BY
-- ORDER BY
-- Subqueries
-- Common Table Expressions (CTE)
-- WITH
-- ROW_NUMBER()
-- RANK()
-- DENSE_RANK()
-- PARTITION BY
-- Window Functions
-- LAG()
-- SUM() OVER()
-- Running Totals
-- STR_TO_DATE()
-- CAST()
-- DATEDIFF()
-- Multiple-table JOINs
-- Aggregate Analysis


-- ============================================
-- End of Section 6: Advanced SQL Analysis
-- ============================================

-- ============================================
-- SQL Murder Mystery
-- Portfolio Project
-- Section 7: Final Investigation Summary
-- ============================================


-- ============================================
-- PART 1: Locate the original murder report
-- ============================================

SELECT
    date,
    type,
    description,
    city
FROM crime_scene_report
WHERE city = 'SQL City'
AND type = 'murder'
AND date = 20180115;


-- ============================================
-- PART 2: Identify the first witness
-- Last house on Northwestern Dr
-- ============================================

SELECT
    id,
    name,
    address_number,
    address_street_name
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;


-- ============================================
-- PART 3: Identify the second witness
-- Annabel on Franklin Ave
-- ============================================

SELECT
    id,
    name,
    address_number,
    address_street_name
FROM person
WHERE name LIKE 'Annabel%'
AND address_street_name = 'Franklin Ave';


-- ============================================
-- PART 4: Retrieve witness interviews
-- ============================================

SELECT
    p.name,
    i.transcript
FROM person AS p
INNER JOIN interview AS i
    ON p.id = i.person_id
WHERE p.id IN (

    SELECT id
    FROM person
    WHERE address_street_name = 'Northwestern Dr'
    ORDER BY address_number DESC
    LIMIT 1

)

OR (

    p.name LIKE 'Annabel%'
    AND p.address_street_name = 'Franklin Ave'

);


-- ============================================
-- PART 5: Identify the murderer
--
-- Witness clues:
-- Membership starts with 48Z
-- Gold membership
-- Gym visit on 2018-01-09
-- Plate contains H42W
-- ============================================

SELECT
    p.id AS person_id,
    p.name,
    m.id AS membership_id,
    m.membership_status,
    c.check_in_date,
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
-- PART 6: Retrieve murderer's interview
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
-- PART 7: Identify the mastermind
--
-- Killer's clues:
-- Female
-- Red hair
-- Height between 65 and 67 inches
-- Tesla Model S
-- Attended SQL Symphony Concert 3 times
-- during December 2017
-- ============================================

WITH concert_attendance AS (

    SELECT
        person_id,
        COUNT(*) AS concert_visits

    FROM facebook_event_checkin

    WHERE event_name = 'SQL Symphony Concert'
    AND date BETWEEN 20171201 AND 20171231

    GROUP BY person_id

    HAVING COUNT(*) = 3

)

SELECT
    p.id AS person_id,
    p.name,
    d.gender,
    d.hair_color,
    d.height,
    d.car_make,
    d.car_model,
    i.annual_income,
    ca.concert_visits

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

INNER JOIN income AS i
    ON p.ssn = i.ssn

INNER JOIN concert_attendance AS ca
    ON p.id = ca.person_id

WHERE d.gender = 'female'
AND d.hair_color = 'red'
AND d.height BETWEEN 65 AND 67
AND d.car_make = 'Tesla'
AND d.car_model = 'Model S';


-- ============================================
-- PART 8: Final Investigation Results
-- ============================================

-- Murderer:
-- Jeremy Bowers
--
-- Mastermind:
-- Miranda Priestly
--
-- The investigation connected evidence across:
--
-- crime_scene_report
-- person
-- interview
-- get_fit_now_member
-- get_fit_now_check_in
-- drivers_license
-- facebook_event_checkin
-- income


-- ============================================
-- PART 9: Verify the Murderer
--
-- Run this only if you want to use the
-- database's built-in solution checker.
-- ============================================

-- INSERT INTO solution
-- VALUES (1, 'Jeremy Bowers');

-- SELECT *
-- FROM solution;


-- ============================================
-- SQL Skills Demonstrated
-- ============================================

-- SELECT
-- WHERE
-- AND / OR
-- LIKE
-- IN
-- BETWEEN
-- ORDER BY
-- LIMIT
-- COUNT()
-- GROUP BY
-- HAVING
-- INNER JOIN
-- Multiple-table JOINs
-- Table aliases
-- Column aliases
-- Subqueries
-- Common Table Expressions (CTE)
-- Window Functions
-- CASE
-- Aggregate Functions
-- Date Analysis


-- ============================================
-- Project Conclusion
-- ============================================

-- This project demonstrates how SQL can be
-- used to investigate interconnected relational
-- datasets and progressively narrow thousands
-- of records into evidence-based conclusions.
--
-- The investigation began with a crime report,
-- identified witnesses, analysed interviews,
-- connected gym records and vehicle information,
-- and finally used event attendance and income
-- information to identify the person responsible
-- for organising the crime.


-- ============================================
-- End of Section 7
-- ============================================


-- =========================================================
-- SQL Murder Mystery
-- Portfolio Project
-- Section 8: Original Data Analysis
--
-- Objective:
-- Perform additional analysis beyond solving the mystery
-- to discover patterns across crime, demographic, income,
-- vehicle, gym and event data.
-- =========================================================


-- =========================================================
-- QUESTION 1
-- Which cities have the highest number of crime reports?
-- =========================================================

SELECT
    city,
    COUNT(*) AS total_crime_reports
FROM crime_scene_report
GROUP BY city
ORDER BY total_crime_reports DESC
LIMIT 10;


-- =========================================================
-- QUESTION 2
-- What are the most common crime types?
-- =========================================================

SELECT
    type,
    COUNT(*) AS total_crimes
FROM crime_scene_report
GROUP BY type
ORDER BY total_crimes DESC;


-- =========================================================
-- QUESTION 3
-- What percentage of all crime reports belongs
-- to each crime category?
-- =========================================================

SELECT
    type,
    COUNT(*) AS total_crimes,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_total

FROM crime_scene_report
GROUP BY type
ORDER BY total_crimes DESC;


-- =========================================================
-- QUESTION 4
-- Which cities have the highest number of murders?
-- =========================================================

SELECT
    city,
    COUNT(*) AS total_murders
FROM crime_scene_report
WHERE type = 'murder'
GROUP BY city
ORDER BY total_murders DESC
LIMIT 10;


-- =========================================================
-- QUESTION 5
-- How have crime reports changed over time by month?
-- =========================================================

SELECT
    DATE_FORMAT(
        STR_TO_DATE(
            CAST(date AS CHAR),
            '%Y%m%d'
        ),
        '%Y-%m'
    ) AS crime_month,

    COUNT(*) AS total_crimes

FROM crime_scene_report

GROUP BY crime_month
ORDER BY crime_month;


-- =========================================================
-- QUESTION 6
-- What is the age distribution of people
-- with driver's licences?
-- =========================================================

SELECT
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        WHEN age BETWEEN 60 AND 69 THEN '60-69'
        ELSE '70+'
    END AS age_group,

    COUNT(*) AS total_people

FROM drivers_license

GROUP BY age_group
ORDER BY MIN(age);


-- =========================================================
-- QUESTION 7
-- What is the average annual income by gender?
-- =========================================================

SELECT
    d.gender,

    COUNT(*) AS total_people,

    ROUND(
        AVG(i.annual_income),
        2
    ) AS average_annual_income

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

INNER JOIN income AS i
    ON p.ssn = i.ssn

GROUP BY d.gender

ORDER BY average_annual_income DESC;


-- =========================================================
-- QUESTION 8
-- Which age groups have the highest average income?
-- =========================================================

SELECT

    CASE
        WHEN d.age < 30 THEN 'Under 30'
        WHEN d.age BETWEEN 30 AND 39 THEN '30-39'
        WHEN d.age BETWEEN 40 AND 49 THEN '40-49'
        WHEN d.age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,

    COUNT(*) AS total_people,

    ROUND(
        AVG(i.annual_income),
        2
    ) AS average_income

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

INNER JOIN income AS i
    ON p.ssn = i.ssn

GROUP BY age_group

ORDER BY average_income DESC;


-- =========================================================
-- QUESTION 9
-- Who are the 10 highest-income people in the database?
-- =========================================================

SELECT
    p.name,
    d.age,
    d.gender,
    i.annual_income

FROM person AS p

INNER JOIN income AS i
    ON p.ssn = i.ssn

LEFT JOIN drivers_license AS d
    ON p.license_id = d.id

ORDER BY i.annual_income DESC

LIMIT 10;


-- =========================================================
-- QUESTION 10
-- Which car manufacturers are most common?
-- =========================================================

SELECT
    car_make,
    COUNT(*) AS total_vehicles

FROM drivers_license

WHERE car_make IS NOT NULL

GROUP BY car_make

ORDER BY total_vehicles DESC

LIMIT 10;


-- =========================================================
-- QUESTION 11
-- What percentage of vehicles belongs to each
-- of the top car manufacturers?
-- =========================================================

WITH car_counts AS (

    SELECT
        car_make,
        COUNT(*) AS total_vehicles

    FROM drivers_license

    WHERE car_make IS NOT NULL

    GROUP BY car_make
),

car_total AS (

    SELECT
        SUM(total_vehicles) AS all_vehicles
    FROM car_counts

)

SELECT
    cc.car_make,
    cc.total_vehicles,

    ROUND(
        cc.total_vehicles * 100.0 /
        ct.all_vehicles,
        2
    ) AS vehicle_percentage

FROM car_counts AS cc

CROSS JOIN car_total AS ct

ORDER BY cc.total_vehicles DESC

LIMIT 10;


-- =========================================================
-- QUESTION 12
-- What is the distribution of gym membership statuses?
-- =========================================================

SELECT
    membership_status,
    COUNT(*) AS total_members

FROM get_fit_now_member

GROUP BY membership_status

ORDER BY total_members DESC;


-- =========================================================
-- QUESTION 13
-- Who are the most active gym members?
-- =========================================================

SELECT
    m.id AS membership_id,
    m.name,
    m.membership_status,
    COUNT(*) AS total_check_ins

FROM get_fit_now_member AS m

INNER JOIN get_fit_now_check_in AS c
    ON m.id = c.membership_id

GROUP BY
    m.id,
    m.name,
    m.membership_status

ORDER BY total_check_ins DESC

LIMIT 10;


-- =========================================================
-- QUESTION 14
-- Which events received the most check-ins?
-- =========================================================

SELECT
    event_name,
    COUNT(*) AS total_check_ins,
    COUNT(DISTINCT person_id) AS unique_attendees

FROM facebook_event_checkin

GROUP BY event_name

ORDER BY total_check_ins DESC

LIMIT 10;


-- =========================================================
-- QUESTION 15
-- Which people attended the greatest number of events?
-- =========================================================

SELECT
    p.name,
    COUNT(*) AS total_event_check_ins,
    COUNT(DISTINCT f.event_name) AS different_events

FROM person AS p

INNER JOIN facebook_event_checkin AS f
    ON p.id = f.person_id

GROUP BY
    p.id,
    p.name

ORDER BY total_event_check_ins DESC

LIMIT 10;


-- =========================================================
-- QUESTION 16
-- Which cities rank highest for crime activity?
-- Advanced analysis using CTE + RANK()
-- =========================================================

WITH city_crime_counts AS (

    SELECT
        city,
        COUNT(*) AS total_crimes

    FROM crime_scene_report

    GROUP BY city
)

SELECT
    city,
    total_crimes,

    RANK() OVER (
        ORDER BY total_crimes DESC
    ) AS crime_rank

FROM city_crime_counts

ORDER BY crime_rank

LIMIT 20;


-- =========================================================
-- QUESTION 17
-- Rank people by income within each gender
-- =========================================================

SELECT
    p.name,
    d.gender,
    i.annual_income,

    DENSE_RANK() OVER (
        PARTITION BY d.gender
        ORDER BY i.annual_income DESC
    ) AS income_rank

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

INNER JOIN income AS i
    ON p.ssn = i.ssn

ORDER BY
    d.gender,
    income_rank;


-- =========================================================
-- QUESTION 18
-- Compare each person's income against the
-- overall average income
-- =========================================================

SELECT
    p.name,
    i.annual_income,

    ROUND(
        AVG(i.annual_income) OVER (),
        2
    ) AS overall_average,

    CASE

        WHEN i.annual_income >
             AVG(i.annual_income) OVER ()
        THEN 'Above Average'

        WHEN i.annual_income <
             AVG(i.annual_income) OVER ()
        THEN 'Below Average'

        ELSE 'Average'

    END AS income_category

FROM person AS p

INNER JOIN income AS i
    ON p.ssn = i.ssn

ORDER BY i.annual_income DESC;


-- =========================================================
-- QUESTION 19
-- Find the top 3 income earners within each gender
-- CTE + ROW_NUMBER + PARTITION BY
-- =========================================================

WITH ranked_people AS (

    SELECT
        p.name,
        d.gender,
        d.age,
        i.annual_income,

        ROW_NUMBER() OVER (
            PARTITION BY d.gender
            ORDER BY i.annual_income DESC
        ) AS income_position

    FROM person AS p

    INNER JOIN drivers_license AS d
        ON p.license_id = d.id

    INNER JOIN income AS i
        ON p.ssn = i.ssn

)

SELECT
    name,
    gender,
    age,
    annual_income,
    income_position

FROM ranked_people

WHERE income_position <= 3

ORDER BY
    gender,
    income_position;


-- =========================================================
-- QUESTION 20
-- Create a simple demographic and financial profile
-- for people with available licence and income data
-- =========================================================

SELECT
    p.name,
    d.age,
    d.gender,
    d.hair_color,
    d.eye_color,
    d.car_make,
    d.car_model,
    i.annual_income,

    CASE

        WHEN i.annual_income >= 150000
            THEN 'High Income'

        WHEN i.annual_income >= 75000
            THEN 'Middle Income'

        ELSE 'Lower Income'

    END AS income_segment

FROM person AS p

INNER JOIN drivers_license AS d
    ON p.license_id = d.id

INNER JOIN income AS i
    ON p.ssn = i.ssn

ORDER BY i.annual_income DESC;


-- =========================================================
-- SQL SKILLS DEMONSTRATED
-- =========================================================

-- SELECT
-- WHERE
-- GROUP BY
-- ORDER BY
-- COUNT()
-- COUNT(DISTINCT)
-- AVG()
-- ROUND()
-- CASE
-- INNER JOIN
-- LEFT JOIN
-- CROSS JOIN
-- Multiple-table JOINs
-- CTE / WITH
-- Window Functions
-- ROW_NUMBER()
-- RANK()
-- DENSE_RANK()
-- PARTITION BY
-- SUM() OVER()
-- STR_TO_DATE()
-- DATE_FORMAT()
-- Percentage Calculations
-- Aggregate Analysis
-- Demographic Analysis
-- Trend Analysis


-- =========================================================
-- End of Section 8: Original Data Analysis
-- =========================================================