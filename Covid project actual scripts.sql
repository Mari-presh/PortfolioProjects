Select * 
From PortfolioProject..CovidDeaths
Where continent is not null
order by 3,4

--Select * 
--From PortfolioProject..CovidVaccinations
--order by 3,4 

--Select data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null
order by 1,2 

--Looking at Total Cases vs Total Deaths
--Use this code foe converting into float datatyoe when "null"
--(Convert(float,total_deaths))/NULLIF(Convert(float,total_cases),0)


Select Location, date, total_cases, total_deaths, (Convert(float,total_deaths))/NULLIF(Convert(float,total_cases),0) *100 as Deathpercentage
From PortfolioProject..CovidDeaths
Where location like'%states%'
and continent!=''
order by 1,2

--Looking at Total Cases vs Population

Select Location, date, population, total_cases,(Convert(float,total_cases))/NULLIF(Convert(float,population),0) *100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like'%states%'
Where continent is not null
order by 1,2

--Looking at countries with highest infection rate compared to population
Select Location, population, Max (total_cases) as HighestInfectionCount, Max((Convert(float,total_cases))/NULLIF(Convert(float,population),0))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like'%states%
Where continent is not null
Group by Location, population
order by PercentPopulationInfected desc

--Looking at Countries with the Higest death count per population

Select Location, Max (cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like'%states%'
Where continent is not null
Group by Location
order by TotalDeathCount desc

--Breaking things by continent
--to show continents with the highest death per population 

Select continent, Max (cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like'%states%'
Where continent!=''
Group by continent
order by TotalDeathCount desc

--showing global numbers
Select date, sum(convert(float,new_cases)),sum(convert(float,new_deaths)), (Convert(float,new_deaths))/ NULLIF (sum(Convert(float,new_cases)),0) *100 as Deathpercentage
From PortfolioProject..CovidDeaths 
--Where location like'%states%'
Where continent!=''
Group by date
order by 1,2

Select sum(convert(float,new_cases)) as totalcases,sum(convert(float,new_deaths)) as totaldeaths, sum(convert(float,new_deaths))/ NULLIF (sum(convert(float,New_cases)),0)*100 as DeathPercentage
From PortfolioProject..CovidDeaths 
--Where location like'%states%'
Where continent!=''
--Group by date
order by 1,2

--Looking at Total Population va Vaccinations
--Use CTE

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea. location Order by dea.location, dea. Date)
 as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent!=''
--order by 2,3
)

Select *, ( Convert (float,RollingPeopleVaccinated)/ NULLIF (Convert (float, population),0))*100 
From PopvsVac

--TEMP TABLE
DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255), 
Date Datetime,
Population float,
New_vaccinations float,
RollingPeopleVaccinated float,
)

Insert into #PercentPopulationVaccinated

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea. location Order by dea.location, dea. Date)
 as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
--Where dea.continent!=''
--order by 2,3


Select *, ( Convert (float,RollingPeopleVaccinated)/ NULLIF (Convert (float, population),0))*100 
From #PercentPopulationVaccinated


--Creating Views to store data for later visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 sum(convert(int,vac.new_vaccinations)) OVER (Partition by dea. location Order by dea.location, dea. Date)
 as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location=vac.location
and dea.date=vac.date
Where dea.continent!=''
--order by 2,3

Select *
From PercentPopulationVaccinated


 












