 --table1
SELECT SUM(new_cases) as totalNewCases, SUM(new_deaths) as TotalNewDeaths,
SUM(new_deaths)/SUM(new_cases)*100 as percentdeath
FROM project1..deaths
WHERE continent is not null

 --table2
SELECT continent, SUM(cast(new_deaths as bigint)) as totalDeaths
FROM project1..deaths
WHERE continent is not null
--and location not in ('World', 'International', 'European Union')
GROUP BY continent
ORDER BY totalDeaths DESC

 --table3
SELECT location, population, MAX(total_cases)as highestcases, 
MAX((total_cases/population))*100 as infectedpercent
FROM project1..deaths
GROUP BY location, population
ORDER BY infectedpercent DESC

 --table4
SELECT location, population,date, MAX(total_cases)as highestcases, 
MAX((total_cases/population))*100 as infectedpercent
FROM project1..deaths
GROUP BY location, population,date
ORDER BY infectedpercent DESC