CREATE OR REPLACE FUNCTION ti.getelementtaxagroupsymmetriestable()
 RETURNS TABLE(elementtaxagroupid integer, symmetryid integer)
 LANGUAGE sql
AS $function$
SELECT elementtaxagroupid, symmetryid
FROM ndb.elementtaxagroupsymmetries
$function$
