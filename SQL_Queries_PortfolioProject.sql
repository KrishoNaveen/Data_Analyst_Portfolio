--Covid cases and deaths data:

SELECT * FROM dbo.Covid_Deaths
WHERE continent is not null
order by 3,4;

SELECT * FROM dbo.Covid_Vaccinations
WHERE continent is not null
order by 3,4;

SELECT location,date,total_cases, new_cases,total_deaths, population
FROM Covid_Portfolio_Project..Covid_Deaths
WHERE continent is not null
order by 1,2;

-- Canada Covid Death Percentage {Total deaths vs Total Cases}

SELECT location,date,total_cases, population, (total_deaths/total_cases)* 100 as Death_Percentage
FROM Covid_Portfolio_Project..Covid_Deaths
WHERE location like '%canada%'
and continent is not null
order by 1,2;

-- India Covid Death Percentage {Total deaths vs Total Cases}

SELECT location,date,total_cases, population, (total_deaths/total_cases)* 100 as Death_Percentage
FROM Covid_Portfolio_Project..Covid_Deaths
WHERE location like '%India%'
and continent is not null
order by 1,2;

-- Total cases vs Population

SELECT location,date,total_cases, population, (total_cases/population)* 100 as Population_Percentage
FROM Covid_Portfolio_Project..Covid_Deaths
WHERE location like '%canada%'
and Continent is not null
order by 1,2;

-- Total deaths vs Population

SELECT location,date,total_deaths, population, (total_deaths/population)* 100 as Population_Death_Percentage
FROM Covid_Portfolio_Project..Covid_Deaths
WHERE location like '%canada%'
and Continent is not null
order by 1,2;

-- Countries with Highest Infection Rate compared to Total Population

Select Location, population, MAX(total_cases) as Highest_Infection_Count, MAX(total_cases/population)* 100 as Percent_Population_Infected
FROM Covid_Portfolio_Project..Covid_Deaths
WHERE Continent is not null
group by location, population
order by 4 desc;

-- Countries with Highest Death rate:

Select Location, MAX(cast(total_deaths as int)) as Highest_Death_Count
FROM Covid_Portfolio_Project..Covid_Deaths
WHERE Continent is not null
group by location
order by Highest_Death_Count desc;

-- Breaking it to continent level { Highest death count vs population}

Select continent, MAX(cast(total_deaths as int)) as Highest_Death_Count
FROM Covid_Portfolio_Project..Covid_Deaths
WHERE Continent is not null
group by continent
order by Highest_Death_Count desc;

-- Global Data exploration:

SELECT date, SUM(new_cases) as Global_total_cases, SUM(cast(new_deaths as int)) as Global_total_deaths, 
(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as Global_Death_percentage
FROM Covid_Portfolio_Project..Covid_Deaths
WHERE continent is not null
GROUP BY date
order by 1,2;

-- Total cases and deaths worldwide:

SELECT SUM(new_cases) as Global_total_cases, SUM(cast(new_deaths as int)) as Global_total_deaths, 
(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as Global_Death_percentage
FROM Covid_Portfolio_Project..Covid_Deaths
WHERE continent is not null
order by 1,2;


-- Covid Vaccinations data:

SELECT * FROM Covid_Portfolio_Project..Covid_Vaccinations;

--Lets join both the tables for better data exploration:

WITH PopvsVacc ( continent, location, date, population, new_vaccinations,Rolling_People_Vaccinated)
as(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated
FROM Covid_Portfolio_Project..Covid_Deaths dea
JOIN Covid_Portfolio_Project..Covid_Vaccinations vac
ON dea.location = vac.location 
and dea.date = vac.date
WHERE dea.continent is not null
--order by 2,3
)
SELECT *, (Rolling_People_Vaccinated/population)*100  FROM PopvsVacc;


-- Creating View for future visualizations:

Create View PercentagePopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as Rolling_People_Vaccinated
FROM Covid_Portfolio_Project..Covid_Deaths dea
JOIN Covid_Portfolio_Project..Covid_Vaccinations vac
ON dea.location = vac.location 
and dea.date = vac.date
WHERE dea.continent is not null

