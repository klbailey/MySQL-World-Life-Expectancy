SELECT * FROM world_life_expectancy.world_life_expectancy;

# 1 Make backup
# 2 Find duplicate rows by row id and filter 
SELECT *
FROM(
	SELECT Row_Id,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
) AS Row_table
WHERE Row_Num > 1
;

# 3 Delete duplicate rows
DELETE FROM world_life_expectancy
WHERE 
	Row_ID IN (
    SELECT Row_ID 
FROM (
	SELECT Row_Id,
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num
	FROM world_life_expectancy
	) AS Row_table
WHERE Row_Num > 1
)
;

# 4 How many blanks or nulls we have
SELECT *
FROM world_life_expectancy
WHERE Status = ''
;

# 5 Do those from #4 have something that is populated we can use for query?
SELECT DISTINCT (Status)
FROM world_life_expectancy
WHERE Status != ''
;

# 6 What are the unique: There are 2 Developing and Developed
SELECT DISTINCT(Country)
FROM world_life_expectancy
WHERE Status = 'Developing';

# 7 If it's a developing country we can populate Status when it is blank if that country has a row where
# the status is populated in another row aka returned from # 6 query
UPDATE world_life_expectancy
SET Status = 'Developing'
WHERE Country IN (
	SELECT DISTINCT(Country)
	FROM world_life_expectancy
	WHERE Status = 'Developing');
    
# 8 Doesn't work. We will join to itself in update statement
# If Afghanistan equal to itself: ON t1.Country = t2.Country THEN if t1.Status = '' AND t2.Status != ''
# And it is developing, we can set t1 to Developing also
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status != ''
AND t2.Status = 'Developing'
;

# 9 Confirm
SELECT *
FROM world_life_expectancy
WHERE Status = ''
;

# 10 USA returned 
SELECT *
FROM world_life_expectancy
WHERE Country = 'United States of America'
;

# 11 Status on fields that are populated show Developed Need to update 'Developed'
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status != ''
AND t2.Status = 'Developed'
;

# 12 Confirm 0 returns
SELECT *
FROM world_life_expectancy
WHERE Status = ''
;

# 13 Check table again for blanks or nulls
SELECT *
FROM world_life_expectancy
;

# 14 some blanks are under Life expectancy
SELECT *
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

# Returns 2 Afghanistan and Albania Row_ID 5, 21
# Take next year and prior year and populate with average as dataset shows slow increase each year
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy;

# 15 if it's blank we populate with average with prior year and next year by self join
SELECT t1.Country, t1.Year, t1.`Life expectancy`, t2.Country, t2.Year, t2.`Life expectancy`
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
;

# Now Afghanistan Year 2018 blank and in next table is Afghanistan Year 2019
# 16 We also need to do exact opposite on another table
SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

# Now Afghanistan Year 2018 blank and in next table is Afghanistan Year 2019, next table Year 2017
# 17 Get average from t2 and t3 and put in t1 and round it so output isn't 76.550000000000000001
SELECT t1.Country, t1.Year, t1.`Life expectancy`, 
t2.Country, t2.Year, t2.`Life expectancy`,
t3.Country, t3.Year, t3.`Life expectancy`,
ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
WHERE t1.`Life expectancy` = ''
;

# 18 Take ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1) to populate blank Life expectancy field
UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
	ON t1.Country = t2.Country
    AND t1.Year = t2.Year - 1
JOIN world_life_expectancy t3
	ON t1.Country = t3.Country
    AND t1.Year = t3.Year + 1
SET t1.`Life expectancy` = ROUND((t2.`Life expectancy` + t3.`Life expectancy`) / 2, 1)
WHERE t1.`Life expectancy` = ''
;

# 19 check table
SELECT Country, Year, `Life expectancy`
FROM world_life_expectancy
WHERE `Life expectancy` = ''
;

# Returns 0