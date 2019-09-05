CREATE OR REPLACE FUNCTION ti.getgeopolunitbynameandhigherid(_geopolname character varying, _highergeopolid integer)
 RETURNS TABLE(geopoliticalid integer, geopoliticalname character varying, geopoliticalunit character varying, rank integer, highergeopoliticalid integer)
 LANGUAGE sql
AS $function$

SELECT     GeoPoliticalID, GeoPoliticalName, GeoPoliticalUnit, Rank, HigherGeoPoliticalID
FROM       NDB.GeoPoliticalUnits
WHERE      (geopoliticalname ILIKE $1) AND (highergeopoliticalid = $2)

$function$
