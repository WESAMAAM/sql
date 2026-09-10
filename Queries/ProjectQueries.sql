-- Population and Total/New Vaccinations over time
-- and finding VaccinationPercentage Based on Total_Vaccinations/Population over time, Useing CTE's

WITH VacOverTime AS 
	(
	SELECT
		CovidDeaths.location,
		FORMAT(CovidDeaths.date, 'yyyy-MM-dd') AS date,
		MAX(CAST(CovidDeaths.population AS float)) AS  population,
		FORMAT(MAX(CAST(Covid_All_Info.new_vaccinations AS float)), 'N0' ) AS  new_vaccinations,
		MAX(CAST(Covid_All_Info.total_vaccinations AS float)) AS  total_vaccinations
	FROM CovidDeaths

	JOIN Covid_All_Info ON Covid_All_Info.location = CovidDeaths.location
		AND Covid_All_Info.date = CovidDeaths.date

	WHERE CovidDeaths.location = 
		'Albania' -- you can change the location to any counrty or continent as you want

	GROUP BY CovidDeaths.date,
			 CovidDeaths.location
	)

SELECT 
	*,
	ROUND((CAST(total_vaccinations AS float))/(CAST(population AS float))*100, 2 ) AS VaccinationPercentage
FROM VacOverTime

ORDER BY date

-- Creating Table for Previous Query but this time for countries

DROP TABLE IF exists #VaccinationForCountries

CREATE TABLE  #VaccinationForCountries
	(
	continent nvarchar (255),
	location nvarchar (255),
	population numeric,
	total_vaccinations float,
	VaccinationPercentage float
	)

INSERT INTO #VaccinationForCountries

SELECT
	continent,
	location,
	MAX(CAST(population AS int)) AS  population,
	MAX(CAST(total_vaccinations AS int)) AS  total_vaccinations,
	ROUND((MAX(CAST(total_vaccinations AS float)))/(MAX(CAST(population AS float)))*100, 2 ) AS VaccinationPercentage
FROM Covid_All_Info

WHERE location NOT IN 
	('World','Europe','North America','South America','European Union','Asia','Africa','Oceania')

GROUP BY location,
		 continent

SELECT *
FROM #VaccinationForCountries

ORDER BY VaccinationPercentage DESC

---------------------------------------------------------------------------------------------------
-- Total_cases vs Total_deaths and DeathPercentage for the WORLD

SELECT
	FORMAT(MAX(CAST(total_cases AS int)), 'N0' ) AS total_cases,
	FORMAT(MAX(CAST(total_deaths AS int)), 'N0' ) AS total_deaths,
	ROUND((MAX(CAST(total_deaths AS float)))/(MAX(CAST(total_cases AS float)))*100, 2) AS DeathPercentage
FROM CovidDeaths

-- Total Cases vs Total Deaths and Showing the liklihood of dying if you contract covid in your country

SELECT
	location,
	FORMAT(MAX(CAST(total_cases AS int)), 'N0' ) AS total_cases,
	FORMAT(MAX(CAST(total_deaths AS int)), 'N0' ) AS total_deaths,
	ROUND((MAX(CAST(total_deaths AS float)))/(MAX(CAST(total_cases AS float)))*100, 2) AS DeathPercentage
FROM CovidDeaths

WHERE location NOT IN 
	('World','Europe','North America','South America','European Union','Asia','Africa','Oceania')

Group BY location

ORDER BY DeathPercentage DESC

-- Total Cases vs Population and Looking at countries with haighest infection rate compared to population

SELECT
	location,
	FORMAT(MAX(CAST(total_cases AS int)), 'N0' ) AS total_cases,
	FORMAT(MAX(CAST(population AS int)), 'N0' ) AS population,
	ROUND((MAX(CAST(total_cases AS float)))/(MAX(CAST(population AS float)))*100, 2) AS ContractPercentage
FROM CovidDeaths

WHERE location NOT IN 
	('World','Europe','North America','South America','European Union','Asia','Africa','Oceania')

GROUP BY location

ORDER BY ContractPercentage DESC

---------------------------------------------------------------------------------------------------
-- Showing the highest death count for continents and the World

SELECT
	location,
	FORMAT(MAX(CAST(total_deaths AS int)), 'N0' ) AS total_deaths
FROM CovidDeaths

WHERE location IN 
	('World','Europe','North America','South America','Asia','Africa','Oceania')

GROUP BY location

ORDER BY MAX(CAST(total_deaths AS int)) DESC

-- Showing the highest death count for countreis

SELECT
	location,
	FORMAT(MAX(CAST(total_deaths AS int)), 'N0' ) AS total_deaths
FROM CovidDeaths

WHERE location NOT IN 
	('World','Europe','North America','South America','European Union','Asia','Africa','Oceania')

GROUP BY location

ORDER BY MAX(CAST(total_deaths AS int)) DESC

---------------------------------------------------------------------------------------------------
-- Showing the death count for countries in specific continents ->
-- Asia:
SELECT
	location,
	FORMAT(MAX(CAST(total_deaths AS int)), 'N0') AS total_deaths
FROM CovidDeaths

WHERE continent = 
	'Asia'

GROUP BY location

ORDER BY MAX(CAST(total_deaths AS int)) DESC

-- Africa
SELECT
	location,
	FORMAT(MAX(CAST(total_deaths AS int)), 'N0') AS total_deaths
FROM CovidDeaths

WHERE continent = 
	'Africa'

GROUP BY location

ORDER BY MAX(CAST(total_deaths AS int)) DESC

-- North America
SELECT
	location,
	FORMAT(MAX(CAST(total_deaths AS int)), 'N0') AS total_deaths
FROM CovidDeaths

WHERE continent = 
	'North America'

GROUP BY location

ORDER BY MAX(CAST(total_deaths AS int)) DESC

-- South America
SELECT
	location,
	FORMAT(MAX(CAST(total_deaths AS int)), 'N0') AS total_deaths
FROM CovidDeaths

WHERE continent = 
	'South America'

GROUP BY location

ORDER BY MAX(CAST(total_deaths AS int)) DESC

-- Europe
SELECT
	location,
	FORMAT(MAX(CAST(total_deaths AS int)), 'N0') AS total_deaths
FROM CovidDeaths

WHERE continent = 
	'Europe'

GROUP BY location

ORDER BY MAX(CAST(total_deaths AS int)) DESC

-- Oceania
SELECT
	location,
	FORMAT(MAX(CAST(total_deaths AS int)), 'N0') AS total_deaths
FROM CovidDeaths

WHERE continent = 
	'Oceania'

GROUP BY location

ORDER BY MAX(CAST(total_deaths AS int)) DESC

---------------------------------------------------------------------------------------------------

-- ~WESAM