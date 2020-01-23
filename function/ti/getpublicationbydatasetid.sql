CREATE OR REPLACE FUNCTION ti.getpublicationbydatasetid(_datasetid integer)
 RETURNS TABLE(datasetid integer, publicationid integer, citation text)
 LANGUAGE sql
AS $function$
SELECT ndb.datasets.datasetid, ndb.publications.publicationid, ndb.publications.citation
FROM ndb.datasets INNER JOIN
                      ndb.datasetpublications ON ndb.datasets.datasetid = ndb.datasetpublications.datasetid INNER JOIN
                      ndb.publications ON ndb.datasetpublications.publicationid = ndb.publications.publicationid
WHERE (ndb.datasets.datasetid = _datasetid);
$function$
