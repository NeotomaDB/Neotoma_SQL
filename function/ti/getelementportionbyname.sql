CREATE OR REPLACE FUNCTION ti.getelementportionbyname(_portion character varying)
 RETURNS TABLE(portionid integer, portion character varying)
AS $$
SELECT portionid, portion
FROM ndb.elementportions
WHERE portion ILIKE $1
$$ LANGUAGE SQL;
