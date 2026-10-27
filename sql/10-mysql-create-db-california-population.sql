-- HAVING a nice day?
-- github.com/sqlxpert/sql-sin-column-refs-having-a-nice-day
-- GPLv3, Copyright Paul Marcelin



-- create database
-- mysql 8.4 (mariadb 11.4)



drop database if exists us_ca_pop;

create database us_ca_pop
  character set utf8mb4
  collate utf8mb4_unicode_ci
;
use us_ca_pop;



create table county_city_population
  (
     county     varchar(25)             not null
       constraint county_length_minimum check ( 2 <= length(county))
       constraint county_space_trimmed  check (county = trim(county))
       constraint county_lowercase      check (county = lower(county))

    ,city       varchar(25)             not null
       constraint city_length_minimum   check ( 2 <= length(city))
       constraint city_space_trimmed    check (city = trim(city))
       constraint city_lowercase        check (city = lower(city))

    ,constraint   co_ci_pop_primary_key primary key (county, city)

    ,population bigint                  not null
       constraint population_minimum    check ( 0 <= population)
  )
  comment 'california 2026-01-01 population by county and city, adapted from dof.ca.gov/forecasting/demographics/price-and-population-factors , PP26AttachmentA_B_C.xlsx , attachment b'
;
