CREATE OR REPLACE FUNCTION ti.getradiocarbonmethodstable()
 RETURNS TABLE(radiocarbonmethodid integer, radiocarbonmethod character varying)
 LANGUAGE sql
AS $function$
SELECT      radiocarbonmethodid, radiocarbonmethod 
 FROM ndb.radiocarbonmethods;
$function$
