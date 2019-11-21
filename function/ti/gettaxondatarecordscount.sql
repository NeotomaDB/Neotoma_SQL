CREATE OR REPLACE FUNCTION ti.gettaxondatarecordscount(_taxonid integer)
 RETURNS TABLE(count bigint)
 LANGUAGE sql
AS $function$
select     count(dt.variableid) as count
from         ndb.variables AS var
  inner join      ndb.data AS dt on var.variableid = dt.variableid
where     (var.taxonid = _taxonid)
$function$
