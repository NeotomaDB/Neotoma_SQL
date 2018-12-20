CREATE OR REPLACE FUNCTION ts.updatetaxonextinct(_taxonid integer, _extinct boolean)
	RETURNS void
	LANGUAGE sql
AS $function$
	UPDATE ndb.taxa AS ta
	SET    extinct = _extinct
	WHERE  ta.taxonid = _taxonid
$function$;
