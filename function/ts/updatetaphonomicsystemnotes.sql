CREATE OR REPLACE FUNCTION ts.updatetaphonomicsystemnotes(_taphonomicsystemid integer, _notes character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.taphonomicsystems AS ts
	SET    notes = _notes
	WHERE  ts.taphonomicsystemid = _taphonomicsystemid
$function$
