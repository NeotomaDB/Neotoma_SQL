CREATE OR REPLACE FUNCTION ts.updatevariabletaxonid(_variableid integer, _newtaxonid integer)
	RETURNS void
	LANGUAGE sql
AS $function$
	UPDATE ndb.variables AS va
	SET    taxonid = _newtaxonid
	WHERE  va.variableid = _variableid
$function$;
