CREATE OR REPLACE FUNCTION ti.getagetypeid(_agetype character varying)
 RETURNS TABLE(agetypeid integer)
AS $$

SELECT agetypeid
FROM  ndb.agetypes at
WHERE at.agetype ILIKE $1;

$$ LANGUAGE SQL;
