--Queries for Tableau Visualizations:

--1.

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Covid_Portfolio_Project..Covid_Deaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2;

--2.
-- In order to maintain data integrity, removing unwanted locations:

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Covid_Portfolio_Project..Covid_Deaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc;

--3.
--Percentage of Population affected:

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_Portfolio_Project..Covid_Deaths
Group by Location, Population
order by PercentPopulationInfected desc;

--4.
-- Highest Infection count on Population per day

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From Covid_Portfolio_Project..Covid_Deaths
Group by Location, Population, date
order by PercentPopulationInfected desc