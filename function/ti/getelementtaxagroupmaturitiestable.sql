CREATE OR REPLACE FUNCTION ti.getelementtaxagroupmaturitiestable()
 RETURNS TABLE(elementtaxagroupid integer, maturityid integer)
 LANGUAGE sql
AS $function$
SELECT elementtaxagroupid, maturityid
FROM ndb.elementtaxagroupmaturities
$function$
