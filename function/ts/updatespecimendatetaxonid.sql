CREATE OR REPLACE FUNCTION ts.updatespecimendatetaxonid(_oldtaxonid integer, _newtaxonid integer)
	RETURNS void
	LANGUAGE sql
AS $function$
	UPDATE ndb.specimendates AS sd
	SET    taxonid = _newtaxonid
	WHERE  sd.taxonid = _oldtaxonid
$function$;
