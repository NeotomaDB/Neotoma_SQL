CREATE OR REPLACE FUNCTION ts.updatetaxonpublicationid(_taxonid integer, _publicationid integer = null)
	RETURNS void
	LANGUAGE sql
AS $function$
	UPDATE ndb.taxa AS ta
	SET    publicationid = _publicationid
	WHERE  ta.taxonid = _taxonid
$function$;
