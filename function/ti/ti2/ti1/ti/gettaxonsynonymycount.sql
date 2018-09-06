CREATE OR REPLACE FUNCTION ti.gettaxonsynonymycount(_taxonid integer)
 RETURNS TABLE(count bigint)
 LANGUAGE sql
AS $function$
  SELECT     COUNT(sy.taxonid) as count
  FROM         ndb.synonymy AS sy
  WHERE     (taxonid = _taxonid)
$function$
