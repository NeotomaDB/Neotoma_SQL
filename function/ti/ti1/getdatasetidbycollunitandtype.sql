CREATE OR REPLACE FUNCTION ti.getdatasetidbycollunitandtype(collunitid integer, datasettypeid integer)
 RETURNS TABLE(datasetid integer)
 LANGUAGE sql
AS $function$

select    datasetid
from      ndb.datasets
where     (datasettypeid = $2) and (collectionunitid = $1)

$function$
