CREATE OR REPLACE FUNCTION ti.getdatasetpublicationids(_datasetid integer)
 RETURNS TABLE(publicationid integer)
 LANGUAGE sql
AS $function$
SELECT publicationid
FROM ndb.datasetpublications
WHERE (datasetid = _datasetid);
$function$
