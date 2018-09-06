CREATE OR REPLACE FUNCTION ti.getgeopoliticalunitstable()
 RETURNS SETOF ndb.geopoliticalunits
 LANGUAGE sql
AS $function$
select *
from ndb.geopoliticalunits;
$function$
