CREATE OR REPLACE FUNCTION ti.getgeochroncontrolcount(_geochronid integer)
 RETURNS TABLE(count integer)
 LANGUAGE sql
AS $function$

SELECT     COUNT(chroncontrolid)::integer AS count
FROM       ndb.geochroncontrols
WHERE     (geochronid = _geochronid)

$function$
