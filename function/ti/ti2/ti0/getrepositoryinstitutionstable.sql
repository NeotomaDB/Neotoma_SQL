CREATE OR REPLACE FUNCTION ti.getrepositoryinstitutionstable()
 RETURNS TABLE(repositoryid integer, acronym character varying, repository character varying, notes text)
 LANGUAGE sql
AS $function$
SELECT       repositoryid, acronym, repository, notes
 FROM ndb.repositoryinstitutions;
$function$
