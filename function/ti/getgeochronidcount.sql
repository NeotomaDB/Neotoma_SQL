CREATE OR REPLACE FUNCTION ti.getgeochronidcount(_geochronid integer)
 RETURNS TABLE(count integer)
 LANGUAGE sql
AS $function$

SELECT COUNT(geochronid)::int AS count
FROM ndb.radiocarbon
WHERE geochronid = $1

$function$
