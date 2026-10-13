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


--Total pop vs vaccination
SELECT death.country, death.date, death.population, vac.new_vaccinations,
   --SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by death.country) this did not work vac.new_vaccinations contains values like '1.39E+06' 
   --(scientific notation stored as text/nvarchar). SQL Server can't convert that directly to int.
   SUM(CAST(CAST(vac.new_vaccinations AS float) AS bigint)) 
    OVER (PARTITION BY death.country)
FROM SQL_PORTFOLIO_PROJECT..covidreport death
JOIN SQL_PORTFOLIO_PROJECT..covidvaccination vac
    ON death.country = vac.country
    AND death.date = vac.date
WHERE death.country is not null
ORDER BY 2, 3

   --USE CTE
With PopvsVac (Country, Date, Population, new_vaccinations)
as
(
SELECT death.country, death.date, death.population, vac.new_vaccinations,
   --SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by death.country) this did not work vac.new_vaccinations contains values like '1.39E+06' 
   --(scientific notation stored as text/nvarchar). SQL Server can't convert that directly to int.
   SUM(CAST(CAST(vac.new_vaccinations AS float) AS bigint)) 
    OVER (PARTITION BY death.country)
FROM SQL_PORTFOLIO_PROJECT..covidreport death
JOIN SQL_PORTFOLIO_PROJECT..covidvaccination vac
    ON death.country = vac.country
    AND death.date = vac.date
WHERE death.country is not null
--ORDER BY 2, 3
)
SELECT *
FROM PopvsVac

--TEMP TABLE

CREATE TABLE #PercentPopVaccinated
(
Country nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric)

INSERT INTO #PercentPopVaccinated
SELECT death.country, death.date, death.population, vac.new_vaccinations,
   --SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by death.country) this did not work vac.new_vaccinations contains values like '1.39E+06' 
   --(scientific notation stored as text/nvarchar). SQL Server can't convert that directly to int.
   SUM(CAST(CAST(vac.new_vaccinations AS float) AS bigint)) 
    OVER (PARTITION BY death.country)
FROM SQL_PORTFOLIO_PROJECT..covidreport death
JOIN SQL_PORTFOLIO_PROJECT..covidvaccination vac
    ON death.country = vac.country
    AND death.date = vac.date
WHERE death.country is not null

--creating VIew to store data for later visualization
CREATE VIEW     