USE sql_murder_mystery;

-- ============================================
-- Section 2: Crime Scene Analysis
-- ============================================

-- Inspect table structure
DESC crime_scene_report;

-- Preview reports
SELECT *
FROM crime_scene_report
LIMIT 10;

-- Count total crime reports
SELECT COUNT(*) AS total_crime_reports
FROM crime_scene_report;

-- Unique crime types
SELECT DISTINCT type
FROM crime_scene_report
ORDER BY type;

-- Count reports by crime type
SELECT type,
       COUNT(*) AS total_reports
FROM crime_scene_report
GROUP BY type
ORDER BY total_reports DESC;

-- All SQL City reports
SELECT *
FROM crime_scene_report
WHERE city = 'SQL City';

-- Murder reports in SQL City
SELECT *
FROM crime_scene_report
WHERE city = 'SQL City'
  AND type = 'murder';

-- SQL City murders ordered by date
SELECT date,
       type,
       description,
       city
FROM crime_scene_report
WHERE city = 'SQL City'
  AND type = 'murder'
ORDER BY date ASC;

-- Murders in January 2018
SELECT *
FROM crime_scene_report
WHERE type = 'murder'
  AND date BETWEEN 20180101 AND 20180131
ORDER BY date;

-- January 2018 murders specifically in SQL City
SELECT date,
       type,
       description,
       city
FROM crime_scene_report
WHERE city = 'SQL City'
  AND type = 'murder'
  AND date BETWEEN 20180101 AND 20180131
ORDER BY date;

-- Search descriptions for witness references
SELECT *
FROM crime_scene_report
WHERE description LIKE '%witness%';

-- SQL City murder reports that mention witnesses
SELECT date,
       description
FROM crime_scene_report
WHERE city = 'SQL City'
  AND type = 'murder'
  AND description LIKE '%witness%';

-- Crime volume by city
SELECT city,
       COUNT(*) AS total_crimes
FROM crime_scene_report
GROUP BY city
ORDER BY total_crimes DESC;

-- Top 10 cities by total reports
SELECT city,
       COUNT(*) AS total_crimes
FROM crime_scene_report
GROUP BY city
ORDER BY total_crimes DESC
LIMIT 10;

-- Murder count by city
SELECT city,
       COUNT(*) AS total_murders
FROM crime_scene_report
WHERE type = 'murder'
GROUP BY city
ORDER BY total_murders DESC;
