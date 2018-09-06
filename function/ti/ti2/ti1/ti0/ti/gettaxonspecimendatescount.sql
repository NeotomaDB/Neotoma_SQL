CREATE OR REPLACE FUNCTION ti.gettaxonspecimendatescount(_taxonid integer)
 RETURNS TABLE(count bigint)
 LANGUAGE sql
AS $function$
select     count(sd.taxonid) as count
from         ndb.specimendates AS sd
where     (sd.taxonid = _taxonid)
$function$
