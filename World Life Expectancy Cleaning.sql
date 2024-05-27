#World Life Expectancy - Data Cleaning
SELECT * 
FROM world_l
ife_expectancy
;


#Identify Duplicates
SELECT Country, Year, CONCAT(Country,Year), COUNT(CONCAT(Country,Year)) 
FROM world_life_expectancy
GROUP BY Country, Year, CONCAT(Country,Year)
HAVING COUNT(CONCAT(Country,Year)) >1
;


#Filter and isolate On the duplicate rows. Any duplicate rows will have a row number of 2
SELECT *
FROM(
	SELECT Row_ID, CONCAT(Country,Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country,Year)) as Row_Num
	FROM world_life_expectancy) AS Row_Table
WHERE  Row_Num > 1
;


#Delete duplicate entries
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
	SELECT Row_ID
FROM (
	SELECT Row_ID, CONCAT(Country,Year),
	ROW_NUMBER() OVER(PARTITION BY CONCAT(Country,Year) ORDER BY CONCAT(Country,Year)) as Row_Num
	FROM world_life_expectancy) AS Row_Table
WHERE  Row_Num > 1
	)
;

#Identify rows where statuses are blank
SELECT *
FROM world_life_expectancy
WHERE Status = ''
;

#Check what are the types of statuses featured in the table
SELECT DISTINCT(Status)
FROM world_life_expectancy
WHERE Status <> ''
;


#Check which countries are developing
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing'
;

#Update blanks with 'Developing' if the country is already developing
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
		ON t1.Country = t2.Country
SET t1.Status ='Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

#Repeat the above query but for developed countries
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
		ON t1.Country = t2.Country
SET t1.Status ='Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;


#Identify blank life expectancies
SELECT *
FROM world_life_expectancy
WHERE `Life Expectancy` = ''
;

#Identify blank life expectancy fields and see what's the value in the year before and after. 
SELECT t1.Country, t1.Year, t1.`Life Expectancy`, 
	   t2.Country, t2.Year, t2.`Life Expectancy`,
       t3.Country, t3.Year, t3.`Life Expectancy`,
       ROUND((t2.`Life expectancy` + t3.`Life expectancy`) /2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year-1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year+1
WHERE t1.`Life expectancy` = ''
;

#Update the blank life expectancies with their averages.
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year-1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year+1
SET t1.`Life Expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) /2,1)
WHERE t1.`Life Expectancy` = ''
;


