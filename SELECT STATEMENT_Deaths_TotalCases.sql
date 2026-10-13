--SELECTING LOCATION, DATE, TOTAL_CASES, NEW_CASES, TOTAL_DEATHS & POPULATION

SELECT *
FROM SQL_PORTFOLIO_PROJECT..covidreport


--Looking at Total Cases vs. Total Deaths
--Shows the likelihood of dying if contracting covid in each countries

SELECT 
    country,
    date,
    total_cases,
    total_deaths,
    (CAST(total_deaths AS FLOAT) / NULLIF(CAST(total_cases AS FLOAT), 0)) * 100 AS DeathPercentage
FROM SQL_PORTFOLIO_PROJECT..covidreport
WHERE country like '%canada%'
ORDER BY 1, 2

--Looking at TotalCases vs Population
--shows percentage of population that has covid
SELECT 
    country,
    date,
    total_cases,
    population,
    (total_cases/population) * 100 AS PercentofPopulationInfected
FROM SQL_PORTFOLIO_PROJECT..covidreport
WHERE country like '%canada%'
ORDER BY 1, 2

--Looking at countries with highest infection rate compared to population

SELECT 
    country,
    population,
    MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)) * 100 AS PercentofPopulationInfected
FROM SQL_PORTFOLIO_PROJECT..covidreport
--WHERE country like '%canada%'
GROUP BY country, population
ORDER BY PercentofPopulationInfected desc

--Showing countries with the highest death count per population
SELECT 
    country, MAX(CAST(Total_deaths AS INT)) as TotalDeathCount
FROM SQL_PORTFOLIO_PROJECT..covidreport
--WHERE country like '%canada%'
GROUP BY country
ORDER BY TotalDeathCount desc

--GLOBAL NUMBERS 
SELECT 
    date, SUM(new_cases) AS Total_cases,SUM(CAST(new_deaths as int)) AS Total_deaths, SUM (new_cases) *100 as DeathPercentage
FROM SQL_PORTFOLIO_PROJECT..covidreport
WHERE country is not null
--WHERE country like '%canada%'
GROUP BY date
ORDER BY 1, 2


--Total pop vs total vaccination
SELECT death.country, death.date, death.population, vac.new_vaccinations
FROM SQL_PORTFOLIO_PROJECT..covidreport death
JOIN SQL_PORTFOLIO_PROJECT..covidvaccination vac
    ON death.country = vac.country
    AND death.date = vac.date
WHERE death.country is not null
ORDER BY 2, 3

   
