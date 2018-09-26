CREATE OR REPLACE FUNCTION ti.getdatasetpublicationstatusv2(_datasetid integer, _publicationid integer)
 RETURNS TABLE(primarypub smallint)
 LANGUAGE sql
AS $function$

SELECT     primarypub
FROM       ndb.datasetpublications
WHERE      (datasetid = _datasetid) and (publicationid = _publicationid)

$function$
