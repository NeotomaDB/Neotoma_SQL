CREATE OR REPLACE FUNCTION ti.getradiocarbonmethodid(_radiocarbonmethod character varying)
 RETURNS TABLE(radiocarbonmethodid integer)
 LANGUAGE sql
AS $function$
SELECT
	 rcm.radiocarbonmethodid
FROM ndb.radiocarbonmethods AS rcm
WHERE radiocarbonmethod ILIKE $1;
$function$
