CREATE OR REPLACE FUNCTION ti.getelementtypebyname(_elementtype character varying)
 RETURNS TABLE(elementtypeid integer, elementtype character varying)
AS $$

SELECT elementtypeid, elementtype
FROM ndb.elementtypes
WHERE elementtype ILIKE $1

$$ LANGUAGE SQL;
