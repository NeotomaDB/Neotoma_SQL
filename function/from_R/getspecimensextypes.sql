CREATE OR REPLACE FUNCTION ti.getspecimensextypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      sexid, sex
 FROM ndb.specimensextypes;
$function$