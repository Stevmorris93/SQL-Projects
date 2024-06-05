#US Project Automated Data Cleaning Project
DELIMITER $$
DROP PROCEDURE IF EXISTS Copy_And_Clean_Data;
CREATE PROCEDURE Copy_And_Clean_Data()
 BEGIN
 #Creating table
	 CREATE TABLE IF NOT EXISTS `us_household_income_Cleaned` (
	  `row_id` int DEFAULT NULL,
	  `id` int DEFAULT NULL,
	  `State_Code` int DEFAULT NULL,
	  `State_Name` text,
	  `State_ab` text,
	  `County` text,
	  `City` text,
	  `Place` text,
	  `Type` text,
	  `Primary` text,
	  `Zip_Code` int DEFAULT NULL,
	  `Area_Code` int DEFAULT NULL,
	  `ALand` int DEFAULT NULL,
	  `AWater` int DEFAULT NULL,
	  `Lat` double DEFAULT NULL,
	  `Lon` double DEFAULT NULL,
	  `TimeStamp` TIMESTAMP DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
    
    #Copy data to new table
    
    INSERT INTO us_project.us_household_income_Cleaned
    SELECT *, CURRENT_TIMESTAMP 
    FROM us_project.us_household_income;
    
    #Delete Duplicates
	DELETE FROM us_project.us_household_income_Cleaned
	WHERE row_id IN(
		SELECT row_id
		FROM(
			SELECT row_id, id,
				ROW_NUMBER() OVER(
					PARTITION BY id, `TimeStamp` 
                    ORDER BY id, `TimeStamp`) AS row_num
			FROM us_project.us_household_income_Cleaned
			) as Row_Table
		WHERE row_num >1 )
	;

#Standardization
	UPDATE us_project.us_household_income_Cleaned
	SET State_Name = 'Georgia'
	WHERE State_Name = 'georia'
	;

	UPDATE us_project.us_household_income_Cleaned
	SET State_Name = 'Alabama'
	WHERE State_Name = 'alabama'
	;

	#Update Blank Field
	UPDATE us_project.us_household_income_Cleaned
	SET Place = 'Autaugaville'
	WHERE City ='Vinemont' AND County = 'Autauga County'
	;

	UPDATE us_project.us_household_income_Cleaned
	SET Type = 'Borough'
	WHERE Type = 'Boroughs'
	;

 END$$
DELIMITER ;
 
CALL Copy_And_Clean_Data();

#Create EVENT
DROP EVENT run_data_cleaning;
CREATE EVENT run_data_cleaning
	ON SCHEDULE EVERY 30 DAY
    DO CALL Copy_And_Clean_Data();


