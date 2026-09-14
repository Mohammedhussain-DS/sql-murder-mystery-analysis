USE sql_murder_mystery;

-- =========================================================
-- Section 8: Original Data Analysis
-- Objective: go beyond solving the mystery and analyse
-- patterns across crime, demographic, income, vehicle,
-- gym, and event data.
-- =========================================================

-- 1. Which cities have the highest number of crime reports?
SELECT city,
       COUNT(*) AS total_crime_reports
FROM crime_scene_report
GROUP BY city
ORDER BY total_crime_reports DESC
LIMIT 10;

-- 2. What are the most common crime types?
SELECT type,
       COUNT(*) AS total_crimes
FROM crime_scene_report
GROUP BY type
ORDER BY total_crimes DESC;

-- 3. What percentage of all reports belongs to each crime category?
SELECT type,
       COUNT(*) AS total_crimes,
       ROUND(
           COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
           2
       ) AS percentage_of_total
FROM crime_scene_report
GROUP BY type
ORDER BY total_crimes DESC;

-- 4. Which cities have the highest number of murders?
SELECT city,
       COUNT(*) AS total_murders
FROM crime_scene_report
WHERE type = 'murder'
GROUP BY city
ORDER BY total_murders DESC
LIMIT 10;

-- 5. How have crime reports changed over time by month?
SELECT DATE_FORMAT(
           STR_TO_DATE(CAST(date AS CHAR), '%Y%m%d'),
           '%Y-%m'
       ) AS crime_month,
       COUNT(*) AS total_crimes
FROM crime_scene_report
GROUP BY crime_month
ORDER BY crime_month;

-- 6. What is the age distribution of licence holders?
SELECT CASE
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

-- 7. What is the average annual income by gender?
SELECT d.gender,
       COUNT(*) AS total_people,
       ROUND(AVG(i.annual_income), 2) AS average_annual_income
FROM person AS p
INNER JOIN drivers_license AS d
        ON p.license_id = d.id
INNER JOIN income AS i
        ON p.ssn = i.ssn
GROUP BY d.gender
ORDER BY average_annual_income DESC;

-- 8. Which age groups have the highest average income?
SELECT CASE
           WHEN d.age < 30 THEN 'Under 30'
           WHEN d.age BETWEEN 30 AND 39 THEN '30-39'
           WHEN d.age BETWEEN 40 AND 49 THEN '40-49'
           WHEN d.age BETWEEN 50 AND 59 THEN '50-59'
           ELSE '60+'
       END AS age_group,
       COUNT(*) AS total_people,
       ROUND(AVG(i.annual_income), 2) AS average_income
FROM person AS p
INNER JOIN drivers_license AS d
        ON p.license_id = d.id
INNER JOIN income AS i
        ON p.ssn = i.ssn
GROUP BY age_group
ORDER BY average_income DESC;

-- 9. Who are the 10 highest-income people?
SELECT p.name,
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

-- 10. Which car manufacturers are most common?
SELECT car_make,
       COUNT(*) AS total_vehicles
FROM drivers_license
WHERE car_make IS NOT NULL
GROUP BY car_make
ORDER BY total_vehicles DESC
LIMIT 10;

-- 11. What percentage of vehicles belongs to each top manufacturer?
WITH car_counts AS (
    SELECT car_make,
           COUNT(*) AS total_vehicles
    FROM drivers_license
    WHERE car_make IS NOT NULL
    GROUP BY car_make
),
car_total AS (
    SELECT SUM(total_vehicles) AS all_vehicles
    FROM car_counts
)
SELECT cc.car_make,
       cc.total_vehicles,
       ROUND(
           cc.total_vehicles * 100.0 / ct.all_vehicles,
           2
       ) AS vehicle_percentage
FROM car_counts AS cc
CROSS JOIN car_total AS ct
ORDER BY cc.total_vehicles DESC
LIMIT 10;

-- 12. What is the distribution of gym membership statuses?
SELECT membership_status,
       COUNT(*) AS total_members
FROM get_fit_now_member
GROUP BY membership_status
ORDER BY total_members DESC;

-- 13. Who are the most active gym members?
SELECT m.id AS membership_id,
       m.name,
       m.membership_status,
       COUNT(*) AS total_check_ins
FROM get_fit_now_member AS m
INNER JOIN get_fit_now_check_in AS c
        ON m.id = c.membership_id
GROUP BY m.id, m.name, m.membership_status
ORDER BY total_check_ins DESC
LIMIT 10;

-- 14. Which events received the most check-ins?
SELECT event_name,
       COUNT(*) AS total_check_ins,
       COUNT(DISTINCT person_id) AS unique_attendees
FROM facebook_event_checkin
GROUP BY event_name
ORDER BY total_check_ins DESC
LIMIT 10;

-- 15. Which people attended the greatest number of events?
SELECT p.name,
       COUNT(*) AS total_event_check_ins,
       COUNT(DISTINCT f.event_name) AS different_events
FROM person AS p
INNER JOIN facebook_event_checkin AS f
        ON p.id = f.person_id
GROUP BY p.id, p.name
ORDER BY total_event_check_ins DESC
LIMIT 10;

-- 16. Rank cities by crime activity using a CTE + RANK()
WITH city_crime_counts AS (
    SELECT city,
           COUNT(*) AS total_crimes
    FROM crime_scene_report
    GROUP BY city
)
SELECT city,
       total_crimes,
       RANK() OVER (
           ORDER BY total_crimes DESC
       ) AS crime_rank
FROM city_crime_counts
ORDER BY crime_rank
LIMIT 20;

-- 17. Rank people by income within each gender
SELECT p.name,
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
ORDER BY d.gender, income_rank;

-- 18. Compare each person's income against the overall average
SELECT p.name,
       i.annual_income,
       ROUND(AVG(i.annual_income) OVER (), 2) AS overall_average,
       CASE
           WHEN i.annual_income > AVG(i.annual_income) OVER () THEN 'Above Average'
           WHEN i.annual_income < AVG(i.annual_income) OVER () THEN 'Below Average'
           ELSE 'Average'
       END AS income_category
FROM person AS p
INNER JOIN income AS i
        ON p.ssn = i.ssn
ORDER BY i.annual_income DESC;

-- 19. Top 3 income earners within each gender
WITH ranked_people AS (
    SELECT p.name,
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
SELECT name,
       gender,
       age,
       annual_income,
       income_position
FROM ranked_people
WHERE income_position <= 3
ORDER BY gender, income_position;

-- 20. Build a demographic + financial profile
SELECT p.name,
       d.age,
       d.gender,
       d.hair_color,
       d.eye_color,
       d.car_make,
       d.car_model,
       i.annual_income,
       CASE
           WHEN i.annual_income >= 150000 THEN 'High Income'
           WHEN i.annual_income >= 75000 THEN 'Middle Income'
           ELSE 'Lower Income'
       END AS income_segment
FROM person AS p
INNER JOIN drivers_license AS d
        ON p.license_id = d.id
INNER JOIN income AS i
        ON p.ssn = i.ssn
ORDER BY i.annual_income DESC;
