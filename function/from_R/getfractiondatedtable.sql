CREATE OR REPLACE FUNCTION ti.getfractiondatedtable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       ndb.fractiondated.*
 FROM ndb.fractiondated;
$function$