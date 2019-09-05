CREATE OR REPLACE FUNCTION ti.getgeochrontypeid(_geochrontype character varying)
 RETURNS TABLE(geochrontypeid integer)
 LANGUAGE sql
AS $function$

SELECT geochrontypeid
FROM ndb.geochrontypes
WHERE geochrontype ILIKE $1

$function$;
