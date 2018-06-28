CREATE OR REPLACE FUNCTION ti.getgeopoliticalunitstable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      ndb.geopoliticalunits.*
 FROM ndb.geopoliticalunits;
$function$