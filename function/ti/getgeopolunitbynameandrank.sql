CREATE OR REPLACE FUNCTION ti.getgeopolunitbynameandrank(_geopolname character varying, _rank integer)
 RETURNS TABLE(geopoliticalid integer, geopoliticalname character varying, geopoliticalunit character varying, rank integer, highergeopoliticalid integer)
 LANGUAGE sql
AS $function$

SELECT     geopoliticalid, geopoliticalname, geopoliticalunit, rank, highergeopoliticalid
FROM       ndb.geopoliticalunits
WHERE      (geopoliticalname ILIKE $1) AND (rank = $2)
ORDER BY geopoliticalname

$function$
