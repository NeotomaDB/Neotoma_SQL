CREATE OR REPLACE FUNCTION ti.getrepositoryinstitution(_acronym character varying DEFAULT NULL, _repository character varying DEFAULT NULL)
 RETURNS TABLE(repositoryid integer, acronym character varying, repository character varying, notes character varying)
 LANGUAGE sql
AS $function$
  select     ri.repositoryid,
             ri.acronym,
             ri.repository,
             ri.notes
  from       ndb.repositoryinstitutions AS ri
  where      (ri.acronym ILIKE _acronym) OR (ri.repository ILIKE _repository)
$function$
