USE sql_murder_mystery;

-- ============================================
-- Section 5: Mastermind Investigation
-- ============================================

-- Clues from the murderer's interview:
-- female, red hair, 65-67 inches tall, Tesla Model S,
-- attended SQL Symphony Concert exactly 3 times in Dec 2017,
-- and has a high income.

DESC facebook_event_checkin;
SELECT * FROM facebook_event_checkin LIMIT 10;

-- Female candidates with red hair
SELECT p.id,
       p.name,
       d.height,
       d.hair_color,
       d.gender
FROM person AS p
INNER JOIN drivers_license AS d
        ON p.license_id = d.id
WHERE d.gender = 'female'
  AND d.hair_color = 'red';

-- Add height clue
SELECT p.id,
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

-- Add Tesla Model S clue
SELECT p.id,
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

-- SQL Symphony Concert visits during December 2017
SELECT *
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
  AND date BETWEEN 20171201 AND 20171231
ORDER BY person_id, date;

-- Count concert visits by person
SELECT person_id,
       COUNT(*) AS concert_visits
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
  AND date BETWEEN 20171201 AND 20171231
GROUP BY person_id
ORDER BY concert_visits DESC;

-- People who attended exactly 3 times
SELECT person_id,
       COUNT(*) AS concert_visits
FROM facebook_event_checkin
WHERE event_name = 'SQL Symphony Concert'
  AND date BETWEEN 20171201 AND 20171231
GROUP BY person_id
HAVING COUNT(*) = 3;

-- Add person names to 3-visit result
SELECT p.id AS person_id,
       p.name,
       COUNT(*) AS concert_visits
FROM person AS p
INNER JOIN facebook_event_checkin AS f
        ON p.id = f.person_id
WHERE f.event_name = 'SQL Symphony Concert'
  AND f.date BETWEEN 20171201 AND 20171231
GROUP BY p.id, p.name
HAVING COUNT(*) = 3;

-- Combine all mastermind clues
SELECT p.id AS person_id,
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
GROUP BY p.id,
         p.name,
         d.height,
         d.hair_color,
         d.gender,
         d.plate_number,
         d.car_make,
         d.car_model
HAVING COUNT(f.person_id) = 3;

-- Inspect income data
DESC income;
SELECT *
FROM income
ORDER BY annual_income DESC
LIMIT 10;

-- Add income to the evidence
SELECT p.id AS person_id,
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
GROUP BY p.id,
         p.name,
         d.height,
         d.hair_color,
         d.gender,
         d.car_make,
         d.car_model,
         i.annual_income
HAVING COUNT(f.person_id) = 3
ORDER BY i.annual_income DESC;

-- CTE version
WITH concert_attendance AS (
    SELECT person_id,
           COUNT(*) AS concert_visits
    FROM facebook_event_checkin
    WHERE event_name = 'SQL Symphony Concert'
      AND date BETWEEN 20171201 AND 20171231
    GROUP BY person_id
    HAVING COUNT(*) = 3
)
SELECT p.id AS person_id,
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

-- Final result: Miranda Priestly
