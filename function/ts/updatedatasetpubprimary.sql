CREATE OR REPLACE FUNCTION ts.updatedatasetpubprimary(_datasetid integer, _publicationid integer, _primary boolean)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.datasetpublications
	SET   primarypub = _primary
	WHERE (datasetid = _datasetid) AND (publicationid = _publicationid)
$function$
