CREATE OR REPLACE FUNCTION ti.getrepositoryinstitution(_acronym character varying, _repository character varying)
 RETURNS TABLE(repositoryid integer, acronym character varying, repository character varying, notes character varying)
 LANGUAGE sql
AS $function$
select     ri.repositoryid, ri.acronym, ri.repository, ri.notes
from       ndb.repositoryinstitutions AS ri
where      (ri.acronym = _acronym) or (ri.repository = _repository)

$function$
