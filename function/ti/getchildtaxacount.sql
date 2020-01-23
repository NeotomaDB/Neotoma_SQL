CREATE OR REPLACE FUNCTION ti.getchildtaxacount(_highertaxonid integer)
 RETURNS TABLE(count INTEGER)
AS $$
SELECT COUNT(highertaxonid)::integer AS count
FROM ndb.taxa
WHERE (highertaxonid <> taxonid) AND (highertaxonid = $1);
$$ LANGUAGE SQL;
