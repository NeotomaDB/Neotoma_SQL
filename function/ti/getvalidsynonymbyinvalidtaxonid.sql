CREATE OR REPLACE FUNCTION ti.getvalidsynonymbyinvalidtaxonid(_invalidtaxonid integer)
 RETURNS TABLE(synonymid integer, invalidtaxonid integer, validtaxonid integer, synonymtypeid integer)
 LANGUAGE sql
AS $function$
SELECT synonymid, invalidtaxonid, validtaxonid, synonymtypeid
FROM ndb.synonyms
WHERE invalidtaxonid = $1

$function$