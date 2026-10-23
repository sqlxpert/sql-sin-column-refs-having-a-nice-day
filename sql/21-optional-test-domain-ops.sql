-- HAVING a nice day?
-- github.com/sqlxpert/sql-sin-column-refs-having-a-nice-day
-- GPLv3, Copyright Paul Marcelin



-- Optional: Test  custom comparison operators for county, city domains
-- Tested with PostgreSQL 18 psql



\connect us_ca_pop
set search_path to us_ca_pop;



select
   test_number
  ,test_name
  ,expected
  ,result
from
   (values
      ( cast(0 as smallint), cast('placeholder' as text), true, true)

     ,(10, 'text    = text'    ,  true, cast('alameda' as text  )  = cast('alameda' as text  ))
     ,(11, 'text   != text'    , false, cast('alameda' as text  ) != cast('alameda' as text  ))

     ,(20, 'county  = county'  ,  true, cast('alameda' as county)  = cast('alameda' as county))
     ,(21, 'city    = city'    ,  true, cast('alameda' as city  )  = cast('alameda' as city  ))

     ,(30, 'county != county'  , false, cast('alameda' as county) != cast('alameda' as county))
     ,(31, 'city   != city'    , false, cast('alameda' as city  ) != cast('alameda' as city  ))

     ,(40, 'county  = city'    , false, cast('alameda' as county)  = cast('alameda' as city  ))
     ,(41, 'city    = county'  , false, cast('alameda' as city  )  = cast('alameda' as county))

     ,(50, 'county != city'    ,  true, cast('alameda' as county) != cast('alameda' as city  ))
     ,(51, 'city   != county'  ,  true, cast('alameda' as city  ) != cast('alameda' as county))

   ) as test_result(
      test_number
     ,test_name
     ,expected
     ,result
   )
order by
   test_number
;