CREATE OR REPLACE FUNCTION ti.gettaxonsynonymscount(_validtaxonid integer)
 RETURNS TABLE(count bigint)
 LANGUAGE sql
AS $function$
select     count(sy.validtaxonid) as count
from         ndb.synonyms AS sy
where     (sy.validtaxonid = _validtaxonid)
$function$
