SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_household_income_statistics;


#Which 10 states have the largest land area
SELECT State_Name, SUM(ALand), SUM(AWater)
FROM us_project.us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10
;

#Join the two main tables
SELECT * 
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id;
    #There are some data that have 0's in Mean, Median, Stdev and sum_w , so we must filter it out
    
SELECT * 
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
WHERE MEAN <> 0;


#Which states have lowest household incomes
SELECT u.State_Name,  ROUND(AVG(Mean),2) as avg_mean, ROUND(AVG(Median),2) as avg_median
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
WHERE MEAN <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10
;

#AVG Income depending on Type. Municipality has a high avg_mean but it only has 1 Count.
SELECT Type, COUNT(Type), ROUND(AVG(Mean),2) as avg_mean, ROUND(AVG(Median),2) as avg_median
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
WHERE MEAN <> 0
GROUP BY 1
ORDER BY 3 DESC
LIMIT 20
;


SELECT * 
FROM  us_household_income
WHERE Type = 'Community'
;


#Which cities have the largest average incomes
SELECT u.State_Name , City, ROUND(AVG(Mean),1) , ROUND(AVG(Median),1) 
FROM us_project.us_household_income AS u
INNER JOIN us_project.us_household_income_statistics AS us
	ON u.id = us.id
GROUP BY u.State_Name, City
ORDER BY 3 DESC;
