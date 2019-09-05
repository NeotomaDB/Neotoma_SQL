CREATE OR REPLACE FUNCTION ti.getfractiondatedbyname(_fraction varchar(80))
RETURNS TABLE(fractionid integer, fraction varchar(80))
AS $$

SELECT fractionid, fraction
FROM ndb.fractiondated
WHERE fraction ILIKE $1 

$$ LANGUAGE SQL;

