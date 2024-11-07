select *
from portfolioproject.coviddeaths
order by 3,4;
select *
from portfolioproject.covidvaccinations
order by 3,4;

ALTER TABLE portfolioproject.covidvaccinations
RENAME COLUMN date TO record_date;


select location, record_date , total_cases, new_cases, total_deaths, population
from portfolioproject.coviddeaths
order by 1,2;

#Looking at Total cases vs Total deaths
#likelihood of dying if you contract covid in your country

select location,record_date,  total_cases, new_cases, (total_deaths/total_cases)* 100 as Death_percentage
from portfolioproject.coviddeaths
where location like  'India%'
order by 1,2;

#Looking at Total cases vs Population
#shows what % of population got covid

select location,record_date, total_cases, population, (total_cases/population)* 100 as case_percentage
from portfolioproject.coviddeaths
order by 1,2;

select location,record_date,  total_cases, population, (total_cases/population)* 100 as case_percentage
from portfolioproject.coviddeaths
order by case_percentage desc;

#looking at countries with Highest_infection_rates compared to Population

select location, population, max(total_cases) as highest_infection_count, max((total_cases/population))* 100 as infection_percentage
from portfolioproject.coviddeaths
group by location, population
order by infection_percentage desc;

select location, population, max(total_cases) as highest_infection_count, max((total_cases/population))* 100 as infection_percentage
from portfolioproject.coviddeaths
where location like  'India%'
group by location, population
order by infection_percentage desc;

#Showing Countries with Highest Death Count per Population
select location, max(cast(total_deaths as float)) as total_death_count
from portfolioproject.coviddeaths
group by location
order by  total_death_count desc;

#LET'S BREAKS THINGS DOWN BY CONTINENT
select location, max(cast(total_deaths as float)) as total_death_count
from portfolioproject.coviddeaths
group by location
order by  total_death_count desc;

#LET'S BREAKS THINGS DOWN BY CONTINENT
select continent, max(cast(total_deaths as float)) as total_death_count
from portfolioproject.coviddeaths
group by continent
order by  total_death_count desc;

#showing the continent with highestDeathCount per Population
select location, max(cast(total_deaths as float)) as total_death_count
from portfolioproject.coviddeaths
where continent is not null
group by location
order by  total_death_count desc;

#GLOBAL NUMBERS
select record_date, sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths , (sum(new_deaths)/sum(new_cases))*100 as deathPercentage
from portfolioproject.coviddeaths
group by record_date
order by deathPercentage desc;

select  sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths , (sum(new_deaths)/sum(new_cases))*100 as deathPercentage
from portfolioproject.coviddeaths
where continent is not null
order by 1,2;

#looking at Total Pop vs Vaccination

SELECT dea.continent, dea.location, dea.record_date,population, vac.new_vaccinations
FROM portfolioproject.coviddeaths dea
join  portfolioproject.covidvaccinations vac
	on dea.location = vac.location
    and dea.record_date = vac.record_date
where dea.continent is not null
order by 1,2,3;

SELECT dea.continent, dea.location, dea.record_date,population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.record_date) as RollingPeoplevaccinated
FROM portfolioproject.coviddeaths dea
join  portfolioproject.covidvaccinations vac
	on dea.location = vac.location
    and dea.record_date = vac.record_date
order by 2,3;

#CTE

with PopvsVacc (continent,location,record_date,population, new_vaccinations, RollingPeoplevaccinated)
as
(
SELECT dea.continent, dea.location, dea.record_date,population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.record_date) as RollingPeoplevaccinated
FROM portfolioproject.coviddeaths dea
join  portfolioproject.covidvaccinations vac
	on dea.location = vac.location
    and dea.record_date = vac.record_date
order by 2,3
)
select *, (RollingPeoplevaccinated/population)*100
from PopvsVacc;

with PopvsVacc (continent,location,population, new_vaccinations, RollingPeoplevaccinated)
as
(
SELECT dea.continent, dea.location,population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.record_date) as RollingPeoplevaccinated
FROM portfolioproject.coviddeaths dea
join  portfolioproject.covidvaccinations vac
	on dea.location = vac.location
    and dea.record_date = vac.record_date
order by 2,3
)
select *, (RollingPeoplevaccinated/population)*100
from PopvsVacc;

#create view to store data for visualisation

create view PercertagePopulationVaccinated as 
SELECT dea.continent, dea.location,population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.record_date) as RollingPeoplevaccinated
FROM portfolioproject.coviddeaths dea
join  portfolioproject.covidvaccinations vac
	on dea.location = vac.location
    and dea.record_date = vac.record_date
order by 2,3;

select * from portfolioproject.percertagepopulationvaccinated











