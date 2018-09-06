CREATE OR REPLACE FUNCTION ti.getvalidsynonymbyinvalidtaxonid(invalidtaxonid integer)
 RETURNS SETOF ndb.synonyms
 LANGUAGE sql
AS $function$
SELECT     sy.*
FROM         ndb.synonyms AS sy
WHERE     (sy.invalidtaxonid = invalidtaxonid)

$function$
