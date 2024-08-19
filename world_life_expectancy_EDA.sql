SELECT * FROM world_life_expectancy.world_life_expectancy;

# 1 What is lowest/highest life expectancy of each country? Using MIN/MAX
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`)
FROM world_life_expectancy
GrOUP BY Country
HAVING MIN(`Life expectancy`) != 0
AND MAX(`Life expectancy`) != 0
ORDER BY Country DESC;

# 2 Which country made biggest stride from lowest to highest? MAX - MIN
SELECT Country, 
MIN(`Life expectancy`), 
MAX(`Life expectancy`),
ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`), 1) AS Life_Increase_15_years
FROM world_life_expectancy
GrOUP BY Country
HAVING MIN(`Life expectancy`) != 0
AND MAX(`Life expectancy`) != 0
ORDER BY Life_Increase_15_years DESC;

# High Haiti 28.7 years; Guyana 1.3 Low however life is at 65-66.3 years
# 3 Look at Average Life Expectancy for each year
SELECT Year, ROUND(AVG(`Life expectancy`), 2)
FROM world_life_expectancy
WHERE `Life expectancy` != 0
AND `Life expectancy` != 0
GROUP BY Year
ORDER BY Year
;

# 2007 66.75 years 2022 71.62 years (lastest year in dataset) numbers are as a whole(world)
# 4 Look at correlation between life expectancy and other columns; example GDP;
# As a country what is average GDP and average life expectancy and compare. Are there any trends?
SELECT Country, ROUND(AVG(`Life expectancy`), 1) AS Life_Expectancy, ROUND(AVG(GDP), 1) AS GDP
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Expectancy > 0
AND GDP > 0
ORDER BY GDP ASC
;

# Somalia life expectancy of 53.3 and GDP average 55.8; Switzerland at 82.3 and 56363.1 as high example
# How many positive correlation? Use Tableau, Power BI connect to datasource in this query
# 5 Bucket and categorize using CASE; when > X then call it high gdp; if high life;
# who has high life expectancy and a high GDP or vice versa; use 1/2 way point ~ 1500
SELECT 
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Life expectancy` ELSE NULL END) High_GDP_Life_expectancy,
SUM(CASE WHEN GDP < 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP < 1500 THEN `Life expectancy` ELSE NULL END) Low_GDP_Life_expectancy
FROM world_life_expectancy
;

# 1326 rows that have high GDP > 1500 and average life expectancy of the 1326 rows is 74.2
# 1612 rows that have low GDP < 1500 and average life expectancy of the 1612 rows is 64.7
# High correlation
# 6 Developing/Developed what is average life expectancy between the two status
SELECT Status, ROUND(AVG(`Life expectancy`), 1)
FROM world_life_expectancy
GROUP BY Status
;

# 7 Developing: 66.8; Developed: 79.2/ Yet, how many countries are in each status?
SELECT Status, COUNT(DISTINCT Country)
FROM world_life_expectancy
GROUP BY Status
;

# 32 countries are Developed; 161 countries are Developing so #6 output is skewed
# 8 combine #6 and #7
SELECT Status, COUNT(DISTINCT Country), ROUND(AVG(`Life expectancy`), 1)
FROM world_life_expectancy
GROUP BY Status
;

# 9 each country has BMI standards and numbers; Break out by country and compare life expectancy
SELECT Country, ROUND(AVG(`Life expectancy`), 1) AS Life_Expectancy, ROUND(AVG(BMI), 1) AS BMI
FROM world_life_expectancy
GROUP BY Country
HAVING Life_Expectancy > 0
AND BMI > 0
ORDER BY BMI ASC
;

# Kiribat 69.4 high BMI, life expectancy 65.1; Viet Nam BMI 11.2, life expectancy 74.8
# 10 Adult Mortality how many people die each year in a country using rolling total
SELECT Country, Year, `Life expectancy`, `Adult Mortality`,
SUM(`Adult Mortality`) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_Total
FROM world_life_expectancy
WHERE Country LIKE '%United%'
;

# US 931 rolling total
SELECT *
FROM world_life_expectancy;



