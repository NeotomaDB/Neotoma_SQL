CREATE OR REPLACE FUNCTION ti.getdatasetrepositoryspecimennotes(_datasetid integer)
 RETURNS TABLE(repositoryid integer,
               notes text)
 LANGUAGE sql
AS $function$
	SELECT rpsp.repositoryid, rpsp.notes
	FROM   ndb.repositoryspecimens AS rpsp
	WHERE  rpsp.datasetid = $1;
$function$
