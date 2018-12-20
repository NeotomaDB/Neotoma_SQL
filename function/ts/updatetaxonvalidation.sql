CREATE OR REPLACE FUNCTION ts.updatetaxonvalidation(_taxonid integer, _validatorid integer, _validatedate character varying)
	RETURNS void
	LANGUAGE sql
AS $function$
	UPDATE ndb.taxa AS ta
	SET    validatorid = _validatorid, validatedate = _validatedate
	WHERE  ta.taxonid = _taxonid
$function$;
