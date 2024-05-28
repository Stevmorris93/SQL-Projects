#US Project Data Cleaning

SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_household_income_statistics;

# The id field is titled 'ï»¿id'. Must alter the table so it only says 'id'
ALTER TABLE us_project.us_household_income_statistics 
RENAME COLUMN `ï»¿id` TO `id`
;


#Getting a count of all the rows
SELECT COUNT(*) 
FROM us_project.us_household_income;

SELECT COUNT(*) 
FROM us_project.us_household_income_statistics;


#Check for duplicates
SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

#Delete Duplicates
DELETE FROM us_project.us_household_income
WHERE row_id IN(
	SELECT row_id
	FROM(
		SELECT row_id, id,
			ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS row_num
		FROM us_project.us_household_income 
		) as Row_Table
	WHERE row_num >1 )
;


#Checking for incorrect spelling of State Names
SELECT DISTINCT State_Name
FROM us_project.us_household_income
ORDER BY 1
;

UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia'
;

UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama'
;


#Checking for blank Place fields
SELECT *
FROM us_project.us_household_income
WHERE Place = ''
ORDER BY 1
;

#Update Blank Field
UPDATE us_project.us_household_income
SET Place = 'Autaugaville'
WHERE City ='Vinemont' AND County = 'Autauga County'
;


#Checking Type
SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type
;

UPDATE us_project.us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs'
;

 
