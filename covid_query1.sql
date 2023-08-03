SELECT location, date, total_cases, new_cases, total_deaths, population
FROM project1..deaths
ORDER BY 1,2

SELECT location, population, total_cases, (total_cases/population)*100 as infectionpercent
FROM project1..deaths
ORDER BY 1,2

SELECT location, population, MAX(total_cases)as highestcases, 
MAX((total_cases/population))*100 as infectedpercent
FROM project1..deaths
GROUP BY location, population
ORDER BY infectedpercent DESC

SELECT location, MAX(cast(total_deaths as bigint)) as totalDeaths
FROM project1..deaths
WHERE continent is not null
GROUP BY location
ORDER BY totalDeaths DESC

SELECT continent, MAX(cast(total_deaths as bigint)) as totalDeaths
FROM project1..deaths
WHERE continent is not null
GROUP BY continent
ORDER BY totalDeaths DESC

SELECT date, SUM(new_cases) as totalNewCases, SUM(new_deaths) as TotalNewDeaths
FROM project1..deaths
GROUP BY date
ORDER BY 1,2

SELECT date, SUM(new_cases) as totalNewCases, SUM(new_deaths) as TotalNewDeaths,
SUM(new_deaths)/SUM(new_cases)*100 as percentdeath
FROM project1..deaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

SELECT SUM(new_cases) as totalNewCases, SUM(new_deaths) as TotalNewDeaths,
SUM(new_deaths)/SUM(new_cases)*100 as percentdeath
FROM project1..deaths
WHERE continent is not null

SELECT det.continent, det.location, det.date, det.population,  vac.total_vaccinations
FROM project1..deaths det
JOIN project1..vaccinations vac
	ON det.location = vac.location
	and det.date = vac.date
WHERE det.continent is not null
ORDER BY 1,2,3 DESC


SELECT det.continent, det.location, det.date, det.population,  vac.new_vaccinations,
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY det.location ORDER BY det.location, det.date) as dailyCount
FROM project1..deaths det
JOIN project1..vaccinations vac
	ON det.location = vac.location
	and det.date = vac.date
WHERE det.continent is not null
ORDER BY 2,3 


WITH populationVaccinated(continent, location,date, population, new_vacc, dailyCount )
AS
(
	SELECT det.continent, det.location, det.date, det.population,  vac.new_vaccinations,
	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY det.location ORDER BY det.location, det.date) as dailyCount
	FROM project1..deaths det
	JOIN project1..vaccinations vac
		ON det.location = vac.location
		and det.date = vac.date
	WHERE det.continent is not null
)
SELECT *, (dailyCount/population)*100 as percentVaccinated
FROM populationVaccinated

--temporay table

DROP table if exists #percentVaccinatedpopulation
CREATE table #percentVaccinatedpopulation
(
continent nvarchar(255),
location nvarchar(255),
date DateTime,
population bigint,
new_vaccinations bigint,
dailyCount bigint
)

INSERT into #percentVaccinatedpopulation

	SELECT det.continent, det.location, det.date, det.population,  vac.new_vaccinations,
	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY det.location ORDER BY det.location, det.date) as dailyCount
	FROM project1..deaths det
	JOIN project1..vaccinations vac
		ON det.location = vac.location
		and det.date = vac.date
	--WHERE det.continent is not null

SELECT *, (dailyCount/population)*100 as percentVaccinated
FROM #percentVaccinatedpopulation

--views

CREATE VIEW 
Vaccinatedpopulation as
	SELECT det.continent, det.location, det.date, det.population,  vac.new_vaccinations,
	SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (PARTITION BY det.location ORDER BY det.location, det.date) as dailyCount
	FROM project1..deaths det
	JOIN project1..vaccinations vac
		ON det.location = vac.location
		and det.date = vac.date
		WHERE det.continent is not null

SELECT * 
FROM Vaccinatedpopulation
		 

