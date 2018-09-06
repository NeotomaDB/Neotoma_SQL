CREATE OR REPLACE FUNCTION ti.getelementsymmetriestable()
 RETURNS TABLE(symmetryid integer, symmetry character varying)
 LANGUAGE sql
AS $function$
SELECT symmetryid, symmetry
FROM ndb.elementsymmetries
$function$
