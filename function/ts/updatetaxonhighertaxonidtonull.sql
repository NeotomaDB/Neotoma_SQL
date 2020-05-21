CREATE OR REPLACE FUNCTION ts.updatetaxonhighertaxonidtonull(_taxonid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.taxa AS ta
	SET    highertaxonid = NULL
	WHERE  ta.taxonid = _taxonid
$function$
