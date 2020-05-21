CREATE OR REPLACE FUNCTION ti.getfractiondatedbyname(_fraction character varying)
 RETURNS TABLE(fractionid integer, fraction character varying)
 LANGUAGE sql
AS $function$

SELECT fractionid, fraction
FROM ndb.fractiondated
WHERE fraction ILIKE $1 

$function$
