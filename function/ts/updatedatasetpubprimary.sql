CREATE OR REPLACE FUNCTION ts.updatedatasetpubprimary(
  _datasetid integer,
  _publicationid integer,
  _primary boolean)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.datasetpublications AS dp
	SET   dp.primarypub = _primary
	WHERE (dp.datasetid = _datasetid) AND (dp.publicationid = _publicationid)
$function$;
