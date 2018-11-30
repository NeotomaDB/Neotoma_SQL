CREATE OR REPLACE FUNCTION ts.updatedepenvthigherid(_depenvtid integer, _depenvthigherid integer)
	RETURNS void
	LANGUAGE sql
AS $function$
	UPDATE ndb.depenvttypes AS det
	SET    depenvthigherid = _depenvthigherid
	WHERE  det.depenvtid = _depenvtid
$function$;
