CREATE OR REPLACE FUNCTION ts.insertrepositoryinstitution(_acronym character varying, _repository character varying, _notes character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.repositoryinstitutions (acronym, repository, notes)
  VALUES (_acronym, _repository, _notes)
  RETURNING repositoryid
$function$;
