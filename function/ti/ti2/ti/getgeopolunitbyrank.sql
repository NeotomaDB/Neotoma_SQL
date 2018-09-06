CREATE OR REPLACE FUNCTION ti.getgeopolunitbyrank(_rank integer)
 RETURNS TABLE(geopoliticalid integer, geopoliticalname character varying, geopoliticalunit character varying, rank integer, highergeopoliticalid integer)
 LANGUAGE sql
AS $function$

SELECT     geopoliticalid, geopoliticalname, geopoliticalunit, rank, highergeopoliticalid
FROM       ndb.geopoliticalunits
WHERE      (rank = _rank)
ORDER BY GeoPoliticalName

$function$
