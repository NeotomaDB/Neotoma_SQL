CREATE OR REPLACE FUNCTION ti.getrepositoryinstitution(_acronym character varying DEFAULT NULL::character varying, _repository character varying DEFAULT NULL::character varying)
 RETURNS TABLE(repositoryid integer, acronym character varying, repository character varying, notes character varying)
 LANGUAGE sql
AS $function$
  SELECT     ri.repositoryid,
             ri.acronym,
             ri.repository,
             ri.notes
  FROM       ndb.repositoryinstitutions AS ri
  WHERE      ((ri.acronym IS NULL) OR (ri.acronym ILIKE _acronym))
    OR    ((ri.repository IS NULL) OR (ri.repository ILIKE _repository))
$function$
