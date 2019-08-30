CREATE OR REPLACE FUNCTION ti.getelementsymmetrybyname(_symmetry character varying)
 RETURNS TABLE(symmetryid integer, symmetry character varying)
AS $$

SELECT symmetryid, symmetry 
FROM ndb.elementsymmetries
WHERE symmetry ILIKE $1

$$ LANGUAGE SQL;
