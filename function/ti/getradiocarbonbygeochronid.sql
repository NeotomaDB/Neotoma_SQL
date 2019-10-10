CREATE OR REPLACE FUNCTION ti.getradiocarbonbygeochronid(_geochronidlist character varying)
 RETURNS TABLE(geochronid integer, radiocarbonmethod character varying, masscmg double precision, percentc double precision, percentn double precision, cnratio double precision, delta13c double precision, delta15n double precision, percentcollagen double precision, reservoir double precision)
 LANGUAGE sql
AS $function$
SELECT        rc.geochronid, rcm.radiocarbonmethod, rc.masscmg, rc.percentc, rc.percentn, rc.cnratio, rc.delta13c, rc.delta15n, rc.percentcollagen, rc.reservoir
FROM          ndb.radiocarbon AS rc INNER JOIN
                  ndb.radiocarbonmethods AS rcm ON rc.radiocarbonmethodid = rcm.radiocarbonmethodid

WHERE       (rc.geochronid IN (
		           SELECT UNNEST(string_to_array(_geochronidlist,'$'))::int))
$function$
