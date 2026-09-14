USE sql_murder_mystery;

-- ============================================
-- Section 7: Final Investigation Summary
-- ============================================

-- 1. Locate the original murder report
SELECT date,
       type,
       description,
       city
FROM crime_scene_report
WHERE city = 'SQL City'
  AND type = 'murder'
  AND date = 20180115;

-- 2. First witness: last house on Northwestern Dr
SELECT id,
       name,
       address_number,
       address_street_name
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;

-- 3. Second witness: Annabel on Franklin Ave
SELECT id,
       name,
       address_number,
       address_street_name
FROM person
WHERE name LIKE 'Annabel%'
  AND address_street_name = 'Franklin Ave';

-- 4. Retrieve both witness interviews without hard-coding the first witness ID
SELECT p.name,
       i.transcript
FROM person AS p
INNER JOIN interview AS i
        ON p.id = i.person_id
WHERE (
        p.address_street_name = 'Northwestern Dr'
        AND p.address_number = (
            SELECT MAX(address_number)
            FROM person
            WHERE address_street_name = 'Northwestern Dr'
        )
      )
   OR (
        p.name LIKE 'Annabel%'
        AND p.address_street_name = 'Franklin Ave'
      );

-- 5. Identify the murderer from gym + vehicle evidence
SELECT p.id AS person_id,
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

-- 6. Retrieve the murderer's interview
SELECT p.name,
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

-- 7. Identify the mastermind
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
-- Final Results
-- ============================================
-- Murderer: Jeremy Bowers
-- Mastermind: Miranda Priestly
--
-- Tables connected during the investigation:
-- crime_scene_report
-- person
-- interview
-- get_fit_now_member
-- get_fit_now_check_in
-- drivers_license
-- facebook_event_checkin
-- income

-- Optional built-in answer checker
-- INSERT INTO solution VALUES (1, 'Jeremy Bowers');
-- SELECT * FROM solution;
