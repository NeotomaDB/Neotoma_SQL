CREATE OR REPLACE FUNCTION ti.getchildtaxacount(hitaxid int)
RETURNS bigint AS $$
SELECT COUNT(highertaxonid) AS count
FROM ndb.taxa
WHERE (highertaxonid <> taxonid) AND (highertaxonid = hitaxid);
$$ LANGUAGE SQL;