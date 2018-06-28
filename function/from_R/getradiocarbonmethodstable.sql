CREATE OR REPLACE FUNCTION ti.getradiocarbonmethodstable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      radiocarbonmethodid, radiocarbonmethod 
 FROM ndb.radiocarbonmethods;
$function$