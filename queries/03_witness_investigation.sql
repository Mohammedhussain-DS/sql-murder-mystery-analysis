USE sql_murder_mystery;

-- ============================================
-- Section 3: Witness Investigation
-- ============================================

-- Find everyone living on Northwestern Dr
SELECT id,
       name,
       address_number,
       address_street_name
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC;

-- First witness: person at the last house on Northwestern Dr
SELECT id,
       name,
       address_number,
       address_street_name
FROM person
WHERE address_street_name = 'Northwestern Dr'
ORDER BY address_number DESC
LIMIT 1;

-- Search people named Annabel
SELECT id,
       name,
       address_number,
       address_street_name
FROM person
WHERE name LIKE 'Annabel%';

-- Second witness: Annabel on Franklin Ave
SELECT id,
       name,
       address_number,
       address_street_name
FROM person
WHERE name LIKE 'Annabel%'
  AND address_street_name = 'Franklin Ave';

-- Inspect interview table
DESC interview;

-- Preview interviews
SELECT *
FROM interview
LIMIT 10;

-- First witness interview
SELECT p.id,
       p.name,
       i.transcript
FROM person AS p
INNER JOIN interview AS i
        ON p.id = i.person_id
WHERE p.address_street_name = 'Northwestern Dr'
ORDER BY p.address_number DESC
LIMIT 1;

-- Second witness interview
SELECT p.id,
       p.name,
       i.transcript
FROM person AS p
INNER JOIN interview AS i
        ON p.id = i.person_id
WHERE p.name LIKE 'Annabel%'
  AND p.address_street_name = 'Franklin Ave';

-- Retrieve both known witness interviews together
SELECT p.id,
       p.name,
       p.address_number,
       p.address_street_name,
       i.transcript
FROM person AS p
INNER JOIN interview AS i
        ON p.id = i.person_id
WHERE p.id IN (14887, 16371);

-- First witness using a scalar subquery
SELECT p.name,
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

-- Investigation findings:
-- Witness 1: Morty Schapiro
-- Witness 2: Annabel Miller
-- Their statements point to a gold Get Fit Now membership,
-- an ID beginning 48Z, a plate containing H42W,
-- and a gym visit on 2018-01-09.
