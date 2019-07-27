CREATE OR REPLACE FUNCTION ti.getdatasetrepository(_datasetid integer)
 RETURNS TABLE(repositoryid integer, acronym character varying, repository character varying, notes text)
 LANGUAGE sql
AS $function$
SELECT ndb.repositoryinstitutions.repositoryid, ndb.repositoryinstitutions.acronym, ndb.repositoryinstitutions.repository, ndb.repositoryinstitutions.notes
FROM ndb.repositoryspecimens INNER JOIN
     ndb.repositoryinstitutions ON ndb.repositoryspecimens.repositoryid = ndb.repositoryinstitutions.repositoryid
WHERE ndb.repositoryspecimens.datasetid = _datasetid;
$function$
