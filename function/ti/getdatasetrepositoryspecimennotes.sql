CREATE OR REPLACE FUNCTION ti.getdatasetrepositoryspecimennotes(datasetid integer)
 RETURNS TABLE(repositoryid integer, notes text)
 LANGUAGE sql
AS $function$

select repositoryid, notes
from   ndb.repositoryspecimens
where  (datasetid = $1)

$function$
