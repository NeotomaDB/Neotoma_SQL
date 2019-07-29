CREATE OR REPLACE FUNCTION ti.getdatasetrepositoryspecimennotes(_datasetid integer)
 RETURNS TABLE(repositoryid integer, notes text)
 LANGUAGE plpgsql
AS $function$
BEGIN
	SELECT repositoryid, notes
	FROM   ndb.repositoryspecimens
	WHERE  datasetid = $1;
END;

$function$
