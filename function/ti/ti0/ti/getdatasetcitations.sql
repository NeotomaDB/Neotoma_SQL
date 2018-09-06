CREATE OR REPLACE FUNCTION ti.getdatasetcitations(_datasetid integer)
 RETURNS TABLE(primarypub smallint, publicationid integer, citation text)
 LANGUAGE sql
AS $function$
SELECT ndb.datasetpublications.primarypub, ndb.publications.publicationid, ndb.publications.citation
FROM ndb.datasetpublications INNER JOIN
     ndb.publications ON ndb.datasetpublications.publicationid = ndb.publications.publicationid
WHERE ndb.datasetpublications.datasetid = _datasetid;
$function$
