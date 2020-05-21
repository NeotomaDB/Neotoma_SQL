CREATE OR REPLACE FUNCTION ts.updatetaxonpublicationid(_taxonid integer, _publicationid integer DEFAULT NULL::integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.taxa AS ta
	SET    publicationid = _publicationid
	WHERE  ta.taxonid = _taxonid
$function$
