CREATE OR REPLACE FUNCTION ti.getdatasetrepository(_datasetid int)
RETURNS TABLE(repositoryid int, acronym varchar(64), repository varchar(128), notes text)
AS $$
SELECT ndb.repositoryinstitutions.repositoryid, ndb.repositoryinstitutions.acronym, ndb.repositoryinstitutions.repository, ndb.repositoryinstitutions.notes
FROM ndb.repositoryspecimens INNER JOIN
     ndb.repositoryinstitutions ON ndb.repositoryspecimens.repositoryid = ndb.repositoryinstitutions.repositoryid
WHERE ndb.repositoryspecimens.datasetid = _datasetid;
$$ LANGUAGE SQL;