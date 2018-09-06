CREATE OR REPLACE FUNCTION ti.getinvalidtaxonsynonymycount(_reftaxonid integer)
 RETURNS TABLE(count integer)
 LANGUAGE sql
AS $function$


SELECT     COUNT(reftaxonid)::integer AS count
FROM         ndb.synonymy
WHERE     (reftaxonid = _reftaxonid);

$function$
