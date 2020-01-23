CREATE OR REPLACE FUNCTION ts.inserttaphonomicsystem(_taphonomicsystem character varying, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.taphonomicsystems (taphonomicsystem, notes)
  VALUES (_taphonomicsystem, _notes)
  RETURNING taphonomicsystemid;
$function$
