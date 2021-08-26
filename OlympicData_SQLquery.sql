-- Exploring the Olympic dataset to find any potential insights:

SELECT * FROM olympic_games..athletes_event_results;

-- Filtering the data based on gender :

SELECT * FROM olympic_games..athletes_event_results
WHERE Sex = 'M' AND Medal <> 'NA';

-- Aggregating the total count of medals and grouping it by Name and ID column:

SELECT Name, ID, COUNT(Medal) as Total_Medals  FROM olympic_games..athletes_event_results
GROUP BY Name, ID;


-- Creating a separate table for visualization purposes:

WITH new_data as (
SELECT ID, 
Name as 'Player Name' ,
CASE WHEN Sex = 'M' THEN 'Male' ELSE 'Female' END As Sex,
Age,
CASE WHEN Age < 18 THEN 'Under 18'
	 WHEN Age BETWEEN 18 AND 25 THEN '18-25'
	 WHEN Age BETWEEN 25 AND 35 THEN '25-35'
	 ELSE 'Over 35'
	 END as Age_grouped,
Height,
Weight,
NOC as 'Nation Code',
LEFT(Games, CHARINDEX(' ', Games)-1) as Year,
RIGHT(Games, CHARINDEX(' ', Reverse(Games)) -1) as Season,
Sport,
Event,
CASE WHEN Medal = 'NA' THEN 'No Medal'
	 ELSE Medal 
	 END as Medal
FROM olympic_games..athletes_event_results)

SELECT * FROM new_data WHERE Season = 'Summer';



