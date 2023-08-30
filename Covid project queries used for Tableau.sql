/*

Queries used for Tableau Project

*/

Select sum(convert(float,new_cases)) as totalcases,sum(convert(float,new_deaths)) as totaldeaths, sum(convert(float,new_deaths))/ NULLIF (sum(convert(float,New_cases)),0)*100 as DeathPercentage
From PortfolioProject..CovidDeaths 
--Where location like'%states%'
Where continent!=''
--Group by date
order by 1,2

--2 where continent ='' means where continent is null; where continent!='' means where continent is not null
Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent =''
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

--3 
Select Location, population, Max (total_cases) as HighestInfectionCount, Max((Convert(float,total_cases))/NULLIF(Convert(float,population),0))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like'%states%
Where continent is not null
Group by Location, population
order by PercentPopulationInfected desc

--4 
Select Location, date, population, total_cases,(Convert(float,total_cases))/NULLIF(Convert(float,population),0) *100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like'%states%'
Where continent is not null
order by PercentPopulationInfected desc