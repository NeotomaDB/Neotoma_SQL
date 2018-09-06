CREATE OR REPLACE FUNCTION ti.getchildtaxacount(hitaxid integer)
 RETURNS bigint
 LANGUAGE sql
AS $function$
SELECT COUNT(highertaxonid) AS count
FROM ndb.taxa
WHERE (highertaxonid <> taxonid) AND (highertaxonid = hitaxid);
$function$
