CREATE OR REPLACE FUNCTION ti.getradiocarbonmethodid(_radiocarbonmethod character varying)
 RETURNS TABLE(_radiocarbonmethodid integer)
 LANGUAGE sql
AS $function$
SELECT
	 rcm.radiocarbonmethodid
FROM ndb.radiocarbonmethods AS rcm
WHERE radiocarbonmethod = $1;
$function$
