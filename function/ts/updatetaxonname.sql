CREATE OR REPLACE FUNCTION ts.updatetaxonname(_taxonid integer, _taxonname character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.taxa AS ta
	SET    taxonname = _taxonname
	WHERE  ta.taxonid = _taxonid
$function$
