SELECT *
FROM crimedata;

-- Duplicate the table for cleaning
CREATE TABLE crime2
LIKE crimedata;

INSERT INTO crime2
SELECT *
FROM crimedata;

-- Check for null values- There are no null values
SELECT *
FROM crime2
WHERE `role` IS NULL;

-- check for inconsistencies
SELECT  distinct `role`
FROM crime2;

SELECT  distinct crime
FROM crime2;

-- check for duplicates - there are no duplicates 
SELECT *, ROW_NUMBER() OVER(PARTITION BY `Person ID`,`Crime ID`,`Date of Birth`) AS row_num
FROM crime2;

with duplicates as (
	SELECT *, ROW_NUMBER() OVER(PARTITION BY `Crime Role ID`,`Person ID`,`Crime ID`,`Date of Birth`,`Crime DateTime`) AS row_num
	FROM crime2
)

SELECT *
FROM duplicates
WHERE row_num>1;

-- How many crimes are listed in the data?
SELECT COUNT(DISTINCT Crime) as number_of_crimes
FROM crime2;

-- What are the different crime types present in the data?
SELECT DISTINCT Crime as crimes
FROM crime2;

-- average number of people involved in a crime 
SELECT ROUND(AVG(`People Involved`),0) as average_num_of_people_involved
FROM crime2;

-- Crime distribution by Gender
SELECT Gender, COUNT(*) as count
FROM crime2
GROUP BY Gender
ORDER BY 2 DESC;

-- What is the most common role among the people involved?
SELECT `Role`,COUNT(*) AS role_count
FROM crime2
GROUP BY `Role`
ORDER BY 2 DESC;

-- How many crimes are resolved?
SELECT Count(*) as resolved_count
FROM crime2
WHERE Resolved =1;

-- How many crimes are unresolved?
SELECT Count(*) as unresolved_count
FROM crime2
WHERE Resolved =0;

-- Victim VS offender by Gender 
SELECT `Role`, Gender, COUNT(*) AS role_count
FROM crime2
GROUP BY `Role`,Gender
ORDER BY 2 DESC;

--  Ethnicity
SELECT Ethnicity, COUNT(*) AS role_count
FROM crime2
GROUP BY 1
ORDER BY 2 DESC;

-- Crime
SELECT Crime, COUNT(role) AS role_count
FROM crime2
GROUP BY 1
ORDER BY 2 DESC;

-- changing the date of birth data type
SELECT `Date of Birth`, STR_TO_DATE(`Date of Birth`,'%m/%d/%Y') AS DOB2
FROM crime2;

UPDATE crime2
SET `Date of Birth` = STR_TO_DATE(`Date of Birth`,'%m/%d/%Y');

SELECT `Date of Birth`
FROM crime2;

 -- Age as of 5th May 2024
SELECT year(current_date()) - year(`Date of Birth`) AS age
FROM crime2;

ALTER TABLE crime2
ADD COLUMN age INT;

UPDATE crime2
SET age = year(current_date()) - year(`Date of Birth`);

SELECT *
FROM crime2;

-- Average age
SELECT ROUND(AVG(age),0) as average_age
FROM crime2;

-- Average age By role
SELECT `Role`,ROUND(AVG(age),0) as average_age
FROM crime2
GROUP BY 1;

-- Average age By crime type
SELECT Crime,ROUND(AVG(age),0) as average_age
FROM crime2
GROUP BY 1;

-- What is the average age of victims and offenders in each crime type?
SELECT Crime,ROUND(AVG(age),0) as average_age
FROM crime2
WHERE `Role` = 'Victim'
GROUP BY 1;

SELECT Crime,ROUND(AVG(age),0) as average_age
FROM crime2
WHERE `Role` = 'Offender'
GROUP BY 1;

 -- What is the distribution of crimes over time? 
-- yearly 
SELECT `Crime Date`, str_to_date(`Crime Date`,'%m/%d/%Y') as date2
FROM crime2;

UPDATE crime2
SET `Crime Date` = str_to_date(`Crime Date`,'%m/%d/%Y');

SELECT year(`Crime Date`) as crime_year,COUNT(*) as count
FROM crime2
GROUP BY 1
ORDER BY 1 DESC;

-- Monthly
ALTER TABLE crime2
ADD COLUMN `Month` VARCHAR(20);

UPDATE crime2
SET `Month` = monthname(`Crime Date`);

SELECT `Month`,Count(*) as count
FROM crime2
GROUP BY 1
ORDER BY 2 DESC;

