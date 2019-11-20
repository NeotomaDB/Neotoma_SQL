CREATE OR REPLACE FUNCTION ti.getdatasetpublicationstatus(_datasetid integer, _publicationid integer)
 RETURNS TABLE(primarypub boolean)
 LANGUAGE sql
AS $function$
	SELECT dspub.primarypub
	FROM ndb.datasetpublications AS dspub
	WHERE dspub.datasetid = $1 AND dspub.publicationid = $2;
$function$
