CREATE OR REPLACE FUNCTION ti.getelementtaxagroupportionstable()
 RETURNS TABLE(elementtaxagroupid integer, portionid integer)
 LANGUAGE sql
AS $function$
SELECT elementtaxagroupid, portionid
FROM ndb.elementtaxagroupportions
$function$
