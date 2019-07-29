CREATE OR REPLACE FUNCTION ti.getdatasetpublicationstatus(_datasetid integer, _publicationid integer)
 RETURNS TABLE(primarypub boolean)
 LANGUAGE plpgsql
AS $function$
BEGIN

	SELECT primarypub
	FROM ndb.datasetpublications
	WHERE datasetid = $1 AND publicationid = $2;

END;

$function$
