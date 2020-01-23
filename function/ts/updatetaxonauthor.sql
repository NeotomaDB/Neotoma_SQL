CREATE OR REPLACE FUNCTION ts.updatetaxonauthor(_taxonid integer, _author character varying = NULL)
	RETURNS void
	LANGUAGE sql
AS $function$
	UPDATE ndb.taxa AS ta
	SET    author = _author
	WHERE  ta.taxonid = _taxonid
$function$;
