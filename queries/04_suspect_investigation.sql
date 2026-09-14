USE sql_murder_mystery;

-- ============================================
-- Section 4: Suspect Investigation
-- ============================================

-- Inspect gym membership and check-in tables
DESC get_fit_now_member;
DESC get_fit_now_check_in;

-- Preview gym data
SELECT * FROM get_fit_now_member LIMIT 10;
SELECT * FROM get_fit_now_check_in LIMIT 10;

-- Membership IDs beginning with 48Z
SELECT *
FROM get_fit_now_member
WHERE id LIKE '48Z%';

-- Gold 48Z members
SELECT id,
       person_id,
       name,
       membership_status
FROM get_fit_now_member
WHERE id LIKE '48Z%'
  AND membership_status = 'gold';

-- Check-ins on 2018-01-09
SELECT *
FROM get_fit_now_check_in
WHERE check_in_date = 20180109;

-- Combine membership and check-in clues
SELECT m.id AS membership_id,
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

-- Connect matching gym members to person records
SELECT p.id AS person_id,
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

-- Driver's licences with plates containing H42W
SELECT id,
       gender,
       plate_number,
       car_make,
       car_model
FROM drivers_license
WHERE plate_number LIKE '%H42W%';

-- Connect plate evidence to people
SELECT p.id AS person_id,
       p.name,
       d.gender,
       d.plate_number,
       d.car_make,
       d.car_model
FROM person AS p
INNER JOIN drivers_license AS d
        ON p.license_id = d.id
WHERE d.plate_number LIKE '%H42W%';

-- Combine all witness clues in one multi-table query
SELECT p.id AS person_id,
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

-- Retrieve the matching suspect's interview
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

-- CTE version of the suspect search
WITH gym_suspects AS (
    SELECT m.person_id,
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
SELECT p.id AS person_id,
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
