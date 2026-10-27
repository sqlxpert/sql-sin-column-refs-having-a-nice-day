-- HAVING a nice day?
-- github.com/sqlxpert/sql-sin-column-refs-having-a-nice-day
-- GPLv3, Copyright Paul Marcelin



-- find counties with population 1 million+
-- postgresql 18, mysql 8.4 (mariadb 11.4)



select 'github.com/sqlxpert/sql-sin-column-refs-having-a-nice-day';



------------------------------------------------------------------------------
select 'california counties with population 1 million+ (syntax question)';
select
   county
  ,sum(population) as population_total
from
   county_city_population
group by
   county
having
  population_total >= 1000000
  -- trick question: is population_total allowed here?
order by
   population_total
;



------------------------------------------------------------------------------
select 'california counties with population 1 million+ (common table expression)';
with

   county_population as (
     select
        county
       ,sum(population) as population_total
     from
        county_city_population
     group by
        county
   )

select
   county
  ,population_total
from
   county_population
where
  population_total >= 1000000
order by
   population_total
;



------------------------------------------------------------------------------
select 'california counties with population 1 million+ (view)';

create or replace view county_population as
  select
     county
    ,sum(population) as population_total
  from
     county_city_population
  group by
     county
;

select
   county
  ,population_total
from
   county_population
where
  population_total >= 1000000
order by
   population_total
;



------------------------------------------------------------------------------
select 'california counties with population 1 million+ (subquery)';
select
   county
  ,population_total
from
   (
     select
        county
       ,sum(population) as population_total
     from
        county_city_population
     group by
        county
   ) as county_population
where
  population_total >= 1000000
order by
   population_total
;



------------------------------------------------------------------------------
select 'california counties with population 1 million+ (column number in order by)';
select
   county                              -- column 1
  ,sum(population) as population_total -- column 2
from
   county_city_population
group by
   county -- column name
having
  sum(population) >= 1000000
  -- population_total column alias not permitted by postgresql 18
  -- must repeat sum(population) expression (bad!)
order by
   2 -- column number used to be required (worse!)
;



------------------------------------------------------------------------------
select 'all sql select statement column reference syntax sins';
select
   county
  ,county              as county2
  ,avg(population)     -- meaningless; gets arbitrary column name
  ,sum(length(county)) -- meaningless; gets arbitrary column name
  ,sum(population)     -- gets duplicate arbitrary column name in postgresql 18
  ,sum(population)     as population_total
  ,count(city)         as cities
from
   county_city_population

group by
   -- column name:
   county

   -- postgresql 18, mysql 8.4 permit column alias:
   -- county2

having
  -- postgresql 18 does not permit column alias
  -- (error: ... "population_total" does not exist):
  -- population_total >= 1000000

  -- must repeat expression from select list in postgresql 18:
  sum(population) >= 1000000

order by
   -- numbered column (column order from select list):
   -- 6  

   -- postgresql 18, mysql 8.4 permit column alias:
   -- population_total

   -- postgresql 18 permits referencing the arbitrary column name:
   -- avg

   -- no way to distinguish duplicate arbitrary column names
   -- (error: ... "sum" is ambiguous):
   -- sum

   -- mysql 8.4 permits referencing the arbitrary column name:
   -- "avg(population)"
;
