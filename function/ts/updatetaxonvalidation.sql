CREATE OR REPLACE FUNCTION ts.updatetaxonvalidation(_taxonid integer, _validatorid integer, _validatedate character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.taxa AS ta
	SET    validatorid = _validatorid,
	       validatedate = TO_DATE(_validatedate, 'YYYY-MM-DD')
	WHERE  ta.taxonid = _taxonid
$function$
