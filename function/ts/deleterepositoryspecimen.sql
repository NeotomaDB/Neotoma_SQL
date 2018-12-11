CREATE OR REPLACE FUNCTION ts.deleterepositoryspecimen(_datasetid INTEGER, _repositoryid INTEGER)
RETURNS void
LANGUAGE sql
AS $function$
  DELETE FROM ndb.repositoryspecimens AS rs
  WHERE       (rs.datasetid = _datasetid) and (rs.repositoryid = _repositoryid)
$function$
