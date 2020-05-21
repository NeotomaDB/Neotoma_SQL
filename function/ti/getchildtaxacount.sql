CREATE OR REPLACE FUNCTION ti.getchildtaxacount(_highertaxonid integer)
 RETURNS TABLE(count integer)
 LANGUAGE sql
AS $function$
SELECT COUNT(highertaxonid)::integer AS count
FROM ndb.taxa
WHERE (highertaxonid <> taxonid) AND (highertaxonid = $1);
$function$
