CREATE OR REPLACE FUNCTION ts.insertdatasetrepository(_datasetid integer, _repositoryid integer, _notes character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.repositoryspecimens(datasetid, repositoryid, notes)
VALUES (_datasetid, _repositoryid, _notes)
$function$;
