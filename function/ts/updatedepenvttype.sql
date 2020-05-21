CREATE OR REPLACE FUNCTION ts.updatedepenvttype(_depenvtid integer, _depenvt character varying, _depenvthigherid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.depenvttypes AS det
	SET    depenvt = _depenvt, depenvthigherid = _depenvthigherid
	WHERE  det.depenvtid = _depenvtid
$function$
