-- HAVING a nice day?
-- github.com/sqlxpert/sql-sin-column-refs-having-a-nice-day
-- GPLv3, Copyright Paul Marcelin



-- optional: create custom comparison operators for county, city domains
-- postgresql 18



create or replace function county_city_not_equal_always (county, city)
  returns boolean

  immutable
  leakproof
  strict
  security invoker
  parallel safe

  language sql
  return true
;

create or replace function county_city_not_equal_always (city, county)
  returns boolean

  immutable
  leakproof
  strict
  security invoker
  parallel safe

  language sql
  return true
;



create or replace function county_city_equal_never (county, city)
  returns boolean

  immutable
  leakproof
  strict
  security invoker
  parallel safe

  language sql
  return false
;

create or replace function county_city_equal_never (city, county)
  returns boolean

  immutable
  leakproof
  strict
  security invoker
  parallel safe

  language sql
  return false
;



create operator  != (
   commutator =  !=
  ,leftarg    = county
  ,rightarg   = city
  ,function   = county_city_not_equal_always
);

create operator   = (
   commutator =   =
  ,leftarg    = county
  ,rightarg   = city
  ,function   = county_city_equal_never

  ,negator    = !=
);



create operator  != (
   commutator =  !=
  ,leftarg    = city
  ,rightarg   = county
  ,function   = county_city_not_equal_always
);

create operator   = (
   commutator =   =
  ,leftarg    = city
  ,rightarg   = county
  ,function   = county_city_equal_never

  ,negator    = !=
);
