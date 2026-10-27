-- HAVING a nice day?
-- github.com/sqlxpert/sql-sin-column-refs-having-a-nice-day
-- GPLv3, Copyright Paul Marcelin



-- create database
-- postgresql 18



drop database if exists us_ca_pop;

create database us_ca_pop
  template        'template0'
  encoding        'UTF8'
  locale_provider 'builtin'
  builtin_locale  'PG_UNICODE_FAST'
;
\connect us_ca_pop

create schema if not exists us_ca_pop;
set search_path to us_ca_pop;



-- _name omitted for brevity and because
-- no other county_ or city_ identifier types are used in this database

create domain place as text
  collate "pg_unicode_fast"
  constraint place_not_null       check (value is not null)

  constraint place_length_minimum check ( 2 <= length(value)      )
  constraint place_length_maximum check (      length(value) <= 25)

  constraint place_space_trimmed  check (value = trim(both from value))
  constraint place_lowercase      check (value = lower(value))
;
comment on domain county is 'california place name';
comment on constraint place_not_null on domain county is
  'also need column constraint in table; see postgresql domain documentation'
;

create domain county as place;
comment on domain county is 'california county name';

create domain city as place;
comment on domain city is 'california city name';



create domain population as bigint
  constraint population_not_null check (value is not null)

  constraint population_minimum  check ( 0 <= value)
;
comment on domain population is 'human population';
comment on constraint population_not_null on domain population is
  'also need column constraint in table; see postgresql domain documentation'
;



create table county_city_population
  (
     county     county     constraint county_not_null     not null
    ,city       city       constraint city_not_null       not null
    ,constraint co_ci_pop_primary_key primary key (county, city)

    ,population population constraint population_not_null not null
  )
;
comment on table county_city_population is
  'california 2026-01-01 population by county and city, adapted from dof.ca.gov/forecasting/demographics/price-and-population-factors , PP26AttachmentA_B_C.xlsx , attachment b'
;
