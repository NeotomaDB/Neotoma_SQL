CREATE OR REPLACE FUNCTION ti.getgeochronidcount(_geochronid int)
RETURNS TABLE(count int)
AS $$

SELECT COUNT(geochronid)::int AS count
FROM ndb.radiocarbon
WHERE geochronid = $1

$$ LANGUAGE SQL;