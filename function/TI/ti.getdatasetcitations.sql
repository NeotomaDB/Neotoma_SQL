CREATE OR REPLACE FUNCTION ti.getdatasetcitations(_datasetid int) RETURNS SETOF record
AS $$
SELECT ndb.datasetpublications.primarypub, ndb.publications.publicationid, ndb.publications.citation
FROM ndb.datasetpublications INNER JOIN
     ndb.publications ON ndb.datasetpublications.publicationid = ndb.publications.publicationid
WHERE ndb.datasetpublications.datasetid = _datasetid;
$$ LANGUAGE SQL;