CREATE OR REPLACE FUNCTION ts.updatetaxoncode(_taxonid integer, _taxoncode character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.taxa AS ta
	SET    taxoncode = _taxoncode
	WHERE  ta.taxonid = _taxonid
$function$
