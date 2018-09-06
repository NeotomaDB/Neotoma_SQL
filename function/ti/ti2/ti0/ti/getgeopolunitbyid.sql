CREATE OR REPLACE FUNCTION ti.getgeopolunitbyid(_geopolid integer)
 RETURNS TABLE(geopoliticalid integer, geopoliticalname character varying, geopoliticalunit character varying, rank integer, highergeopoliticalid integer)
 LANGUAGE sql
AS $function$

SELECT  geopoliticalid, geopoliticalname, geopoliticalunit, rank, highergeopoliticalid
FROM       ndb.geopoliticalunits
WHERE      (geopoliticalid = _geopolid)


$function$
