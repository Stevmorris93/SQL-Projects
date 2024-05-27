#World Life Expectancy - Exploratory Data Analysis

SELECT *
FROM world_life_expectancy;


#Examine life expectancy growth
SELECT Country, 
	   MIN(`Life expectancy`) as Min_Life_Expectancy,
       MAX(`Life expectancy`) AS Max_Life_Expectancy,
       ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`) , 1) AS Life_Increase_15_Years
FROM world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) != 0 
	AND MAX(`Life expectancy`) != 0
ORDER BY Life_Increase_15_Years DESC
;


#Global Average Life Expectancy
SELECT Year, ROUND(AVG(`Life expectancy`), 2) AS Avg_Life_Expectancy
FROM world_life_expectancy
WHERE `Life expectancy` <>0
GROUP BY Year
ORDER BY Year;


#Check the correlation between Life Expectancy and GDP 
SELECT Country,  ROUND(AVG( `Life expectancy`), 1) AS Avg_Life_Expectancy , ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY COUNTRY
HAVING Avg_Life_Expectancy > 0
	AND GDP > 0
ORDER BY GDP DESC
;

#Further Correlating High and Low GDP with life expectancy
SELECT
	SUM(CASE WHEN GDP >=1500 THEN 1 ELSE 0 END) AS High_GDP_Count,
    AVG(CASE WHEN GDP >=1500 THEN `Life expectancy` ELSE NULL END) AS High_GDP_Life_Expectancy,
	SUM(CASE WHEN GDP <=1500 THEN 1 ELSE 0 END) AS Low_GDP_Count,
    AVG(CASE WHEN GDP <=1500 THEN `Life expectancy` ELSE NULL END) AS Low_GDP_Life_Expectancy    
FROM world_life_expectancy	
;


#Correlating Status and Life Expectancy
SELECT Status, ROUND(AVG(`Life expectancy`),1) 
FROM world_life_expectancy
GROUP BY Status
;

#Determine how many Developed vs Developing countries there are
SELECT Status, COUNT(DISTINCT COUNTRY), ROUND(AVG(`Life expectancy`),1) 
FROM world_life_expectancy 
GROUP BY Status
;

#Correlate BMI
SELECT Country, ROUND(AVG( `Life expectancy`), 1) AS Avg_Life_Expectancy , ROUND(AVG(BMI), 1) AS BMI
FROM world_life_expectancy
GROUP BY COUNTRY
HAVING Avg_Life_Expectancy > 0
	AND BMI > 0
ORDER BY BMI DESC
;#BMI doesnt have a strong direct correlation to life expectancy


#Seeing how adult mortality has progressed over 15 years
SELECT Country, Year, `Life expectancy`, `Adult Mortality`,
	SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
