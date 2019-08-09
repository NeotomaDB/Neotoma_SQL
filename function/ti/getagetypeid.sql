CREATE OR REPLACE FUNCTION ti.getagetypeid(_agetype character varying)
 RETURNS TABLE(agetypeid integer)
AS $$

SELECT agetypeid
FROM  ndb.agetypes at
WHERE at.agetype = $1;

$$ LANGUAGE SQL;
