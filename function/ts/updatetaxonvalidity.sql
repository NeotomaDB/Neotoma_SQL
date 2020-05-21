CREATE OR REPLACE FUNCTION ts.updatetaxonvalidity(_taxonid integer, _valid boolean)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.taxa AS ta
	SET    valid = _valid
	WHERE  ta.taxonid = _taxonid
$function$
