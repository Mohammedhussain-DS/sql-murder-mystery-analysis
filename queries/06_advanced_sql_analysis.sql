USE sql_murder_mystery;

-- ============================================
-- Section 6: Advanced SQL Analysis
-- ============================================

-- 1. Categorise people into age groups using CASE
SELECT p.name,
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

-- 2. Count people in each age group
SELECT CASE
           WHEN age < 20 THEN 'Under 20'
           WHEN age BETWEEN 20 AND 39 THEN '20-39'
           WHEN age BETWEEN 40 AND 59 THEN '40-59'
           ELSE '60+'
       END AS age_group,
       COUNT(*) AS total_people
FROM drivers_license
GROUP BY age_group
ORDER BY total_people DESC;

-- 3. Categorise income levels
SELECT p.name,
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

-- 4. Average income
SELECT ROUND(AVG(annual_income), 2) AS average_income
FROM income;

-- 5. People earning above average using a subquery
SELECT p.name,
       i.annual_income
FROM person AS p
INNER JOIN income AS i
        ON p.ssn = i.ssn
WHERE i.annual_income > (
    SELECT AVG(annual_income)
    FROM income
)
ORDER BY i.annual_income DESC;

-- 6. Rank everyone by annual income
SELECT p.name,
       i.annual_income,
       ROW_NUMBER() OVER (
           ORDER BY i.annual_income DESC
       ) AS income_row_number
FROM person AS p
INNER JOIN income AS i
        ON p.ssn = i.ssn;

-- 7. Compare ROW_NUMBER, RANK and DENSE_RANK
SELECT p.name,
       i.annual_income,
       ROW_NUMBER() OVER (ORDER BY i.annual_income DESC) AS row_number_rank,
       RANK() OVER (ORDER BY i.annual_income DESC) AS normal_rank,
       DENSE_RANK() OVER (ORDER BY i.annual_income DESC) AS dense_rank
FROM person AS p
INNER JOIN income AS i
        ON p.ssn = i.ssn
LIMIT 50;

-- 8. Rank income within each gender
SELECT p.name,
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
ORDER BY d.gender, income_rank_within_gender;

-- 9. Top 3 earners within each gender using CTE + ROW_NUMBER
WITH ranked_income AS (
    SELECT p.name,
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
SELECT name,
       gender,
       annual_income,
       income_rank
FROM ranked_income
WHERE income_rank <= 3
ORDER BY gender, income_rank;

-- 10. Most common car manufacturers
SELECT car_make,
       COUNT(*) AS total_cars
FROM drivers_license
WHERE car_make IS NOT NULL
GROUP BY car_make
ORDER BY total_cars DESC
LIMIT 10;

-- 11. Rank car manufacturers by popularity
WITH car_counts AS (
    SELECT car_make,
           COUNT(*) AS total_cars
    FROM drivers_license
    WHERE car_make IS NOT NULL
    GROUP BY car_make
)
SELECT car_make,
       total_cars,
       DENSE_RANK() OVER (
           ORDER BY total_cars DESC
       ) AS popularity_rank
FROM car_counts
ORDER BY popularity_rank;

-- 12. Most active gym members
SELECT m.id AS membership_id,
       m.name,
       COUNT(*) AS total_check_ins
FROM get_fit_now_member AS m
INNER JOIN get_fit_now_check_in AS c
        ON m.id = c.membership_id
GROUP BY m.id, m.name
ORDER BY total_check_ins DESC
LIMIT 20;

-- 13. Rank gym members by visits
WITH gym_visits AS (
    SELECT m.id AS membership_id,
           m.name,
           COUNT(*) AS total_visits
    FROM get_fit_now_member AS m
    INNER JOIN get_fit_now_check_in AS c
            ON m.id = c.membership_id
    GROUP BY m.id, m.name
)
SELECT membership_id,
       name,
       total_visits,
       RANK() OVER (
           ORDER BY total_visits DESC
       ) AS visit_rank
FROM gym_visits
ORDER BY visit_rank;

-- 14. Most frequently attended events
SELECT event_name,
       COUNT(*) AS total_check_ins
FROM facebook_event_checkin
GROUP BY event_name
ORDER BY total_check_ins DESC
LIMIT 20;

-- 15. Rank events by attendance
WITH event_attendance AS (
    SELECT event_name,
           COUNT(*) AS total_attendance
    FROM facebook_event_checkin
    GROUP BY event_name
)
SELECT event_name,
       total_attendance,
       DENSE_RANK() OVER (
           ORDER BY total_attendance DESC
       ) AS event_rank
FROM event_attendance
ORDER BY event_rank
LIMIT 20;

-- 16. Percentage of crime reports represented by each type
SELECT type,
       COUNT(*) AS total_crimes,
       ROUND(
           COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
           2
       ) AS percentage_of_total
FROM crime_scene_report
GROUP BY type
ORDER BY total_crimes DESC;

-- 17. Convert integer dates into real MySQL dates
SELECT date AS original_date,
       STR_TO_DATE(CAST(date AS CHAR), '%Y%m%d') AS formatted_date,
       type,
       city
FROM crime_scene_report
LIMIT 20;

-- 18. Compare each crime date with the previous report in the same city
SELECT city,
       STR_TO_DATE(CAST(date AS CHAR), '%Y%m%d') AS crime_date,
       type,
       LAG(STR_TO_DATE(CAST(date AS CHAR), '%Y%m%d')) OVER (
           PARTITION BY city
           ORDER BY date
       ) AS previous_crime_date
FROM crime_scene_report
ORDER BY city, date;

-- 19. Running total of event check-ins
WITH daily_events AS (
    SELECT date,
           COUNT(*) AS daily_check_ins
    FROM facebook_event_checkin
    GROUP BY date
)
SELECT date,
       daily_check_ins,
       SUM(daily_check_ins) OVER (
           ORDER BY date
       ) AS running_total
FROM daily_events
ORDER BY date;

-- 20. Compare each person's income with their gender average
WITH income_comparison AS (
    SELECT p.name,
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
SELECT name,
       gender,
       annual_income,
       ROUND(gender_average_income, 2) AS gender_average_income,
       CASE
           WHEN annual_income > gender_average_income THEN 'Above Average'
           WHEN annual_income < gender_average_income THEN 'Below Average'
           ELSE 'Average'
       END AS income_position
FROM income_comparison
ORDER BY annual_income DESC;
