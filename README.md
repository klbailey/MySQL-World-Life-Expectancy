# MySQL World Life Expectancy

Project Summary: World Life Expectancy Data Cleaning

- Backup: Created a backup of the original dataset.
- Duplicate Removal: Identified and deleted duplicate rows based on row IDs.
- Null/Blank Values: Assessed the dataset for blanks or nulls and determined if existing populated data could be used for replacement.
- Status Field Population: Identified unique statuses (Developed and Developing) and populated missing Status fields for developing countries by self-joining on the same country where Status was populated.
- Life Expectancy Calculation: For records with missing Life expectancy, calculated the average of the previous and next years' life expectancy values using a self-join, then populated the missing values.
- Validation: Repeated checks to ensure all missing data was accurately filled, confirming no nulls or blanks remained in critical fields like Status and Life expectancy.

Project Summary: SQL Queries for Life Expectancy Analysis

- Lowest/Highest Life Expectancy: Identifies the minimum and maximum life expectancy for each country.
- Biggest Stride: Calculates the largest increase in life expectancy for each country.
- Average Life Expectancy by Year: Computes the average life expectancy for each year.
- Correlation with GDP: Analyzes the relationship between average GDP and life expectancy by country.
- GDP Buckets: Categorizes countries based on GDP thresholds and calculates average life expectancy for each category.
- Developing vs. Developed: Compares average life expectancy between developing and developed countries.
- Country Count by Status: Counts the number of countries in each status category.
- Combined Stats: Merges life expectancy and country count data by status.
- Life Expectancy vs. BMI: Examines the relationship between life expectancy and BMI by country.
- Adult Mortality Rolling Total: Calculates the rolling total of adult mortality for countries with "United" in their name.
