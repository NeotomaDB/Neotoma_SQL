CREATE OR REPLACE FUNCTION ti.getrepositoryinstitutionstable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       repositoryid, acronym, repository, notes
 FROM ndb.repositoryinstitutions;
$function$