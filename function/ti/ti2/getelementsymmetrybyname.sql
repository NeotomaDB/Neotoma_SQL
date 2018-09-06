CREATE OR REPLACE FUNCTION ti.getelementsymmetrybyname(_symmetry character varying)
 RETURNS TABLE(symmetryid integer, symmetry character varying)
 LANGUAGE sql
AS $function$
SELECT symmetryid, symmetry 
FROM ndb.elementsymmetries
WHERE symmetry = _symmetry 
$function$
