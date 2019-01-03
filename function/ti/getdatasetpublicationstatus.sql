CREATE OR REPLACE FUNCTION ti.getdatasetpublicationstatus(datasetid integer, publicationid integer)
 RETURNS TABLE(primarypub boolean)
 LANGUAGE sql
AS $function$

select     primarypub
from       ndb.datasetpublications
where      (datasetid = $1) and (publicationid = $2)

$function$
