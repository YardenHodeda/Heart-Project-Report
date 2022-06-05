# CREATING THE SCHEMA & SELECTING THE TABLES 
CREATE SCHEMA heart_project;
USE	heart_project;
SELECT *
FROM diseases
LIMIT 10;
SELECT *
FROM marks
LIMIT 10;

# HOW MANY RECORDS DO WE HAVE
SELECT COUNT(*) as 'Total'
FROM diseases;
SET @Total = 319795;

# WHAT IS THE HEART DISEASE % DISTRIBUTION
SELECT (COUNT(*)/@Total)*100 AS 'With_HeartDisease'
FROM diseases
WHERE HeartDisease = "Yes";

# WHAT IS THE RELATIONSHIP BETWEEN GENRAL HEALTH AND HEART DISEASE
SELECT HeartDisease, GenHealth, HeartDisease, COUNT(*) AS Total_Number
FROM diseases
WHERE (HeartDisease = 'Yes')
GROUP BY GenHealth;  

# WHET IS THE DISTRIBUTION BY GENDER
SELECT Sex, (COUNT(*)/@TotalHeartDisease)*100 AS TotalPercentage
FROM diseases d
JOIN marks m
	ON d.number = m.number
WHERE d.HeartDisease = 'Yes'
GROUP BY Sex;

# WHAT IS THE EFFECT OF BMI ON PHYSICAL HEALTH AND HEART DISEASE
SELECT m.number, m.Sex, m.BMI, m.PhysicalHealth, d.HeartDisease
FROM  diseases d
JOIN marks m
	ON d.number = m.number;
    
# DOES AGE PLAY A ROLE WHEN IN COMES TO HEART DISEASE
-- Creating a temp table to store the date for calculations
DROP TABLE IF EXISTS TempTable;
CREATE TABLE TempTable (AgeCategory VARCHAR(15), HeartDisease VARCHAR(3) , TotalNumber INT);
-- Inserting values into the temp table
INSERT INTO TempTable
SELECT m.AgeCategory, d.HeartDisease, COUNT(*) AS TotalNumber
FROM  diseases d
JOIN marks m
	ON d.number = m.number 
WHERE d.HeartDisease = 'Yes'
GROUP BY m.AgeCategory;
-- Confirming the table
SELECT *
FROM TempTable;
-- Getting number of people with heart disease 
SELECT *, SUM(TotalNumber) OVER(ORDER BY AgeCategory DESC) AS CumulativeSum
FROM TempTable;
SET @TotalHeartDisease = 27373;
-- Making the calculation and showing the final table
SELECT AgeCategory, (TotalNumber/@TotalHeartDisease)*100 AS TotalPercentage
FROM TempTable
ORDER BY 1 DESC;

# WHAT OTHER MARKS ARE POPULAR WITH PEOPLE WITH HEART DISEASE
-- Heart disease & sleep deprived 
SELECT (COUNT(*)/@TotalHeartDisease)*100 AS Marks
FROM marks 
WHERE SleepTime < 7 AND HeartDisease = 'Yes'
UNION
-- Heart disease & smoking
SELECT (COUNT(*)/@TotalHeartDisease)*100 
FROM marks 
WHERE Smoking = 'Yes' AND HeartDisease = 'Yes'
UNION
-- Heart disease & alcohol drinking
SELECT (COUNT(*)/@TotalHeartDisease)*100 
FROM marks 
WHERE AlcoholDrinking = 'Yes' AND HeartDisease = 'Yes'
UNION
-- Heart disease & no physical activity
SELECT (COUNT(*)/@TotalHeartDisease)*100 
FROM marks 
WHERE PhysicalActivity = 'No' AND HeartDisease = 'Yes';

#DOES YOUR RACE HAVE AN EFFECT ON HEART DISEASE
SELECT Race, (COUNT(*)/@TotalHeartDisease)*100
FROM marks
WHERE HeartDisease = 'Yes'
GROUP BY Race;

# WHAT ARE THE COMMON DISEASES THAT PEOPLE WITH HEART DISEASE HAS
 -- Heart disease & Asthma 
SELECT (COUNT(*)/@TotalHeartDisease)*100 AS diseases 
FROM diseases 
WHERE Asthma LIKE 'Y%' AND HeartDisease = 'Yes'
UNION
-- Heart disease & KidneyDisease
SELECT (COUNT(*)/@TotalHeartDisease)*100 
FROM diseases 
WHERE KidneyDisease LIKE 'Y%' AND HeartDisease = 'Yes'
UNION
-- Heart disease & SkinCancer
SELECT (COUNT(*)/@TotalHeartDisease)*100  
FROM diseases 
WHERE SkinCancer LIKE 'Y%' AND HeartDisease = 'Yes'
UNION
-- Heart disease & Diabetic
SELECT (COUNT(*)/@TotalHeartDisease)*100
FROM diseases 
WHERE Diabetic LIKE 'Y%' AND HeartDisease = 'Yes'
UNION
-- Heart disease & Stroke
SELECT (COUNT(*)/@TotalHeartDisease)*100
FROM diseases 
WHERE Stroke LIKE 'Y%' AND HeartDisease = 'Yes';
