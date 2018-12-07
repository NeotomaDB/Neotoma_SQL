CREATE OR REPLACE FUNCTION ts.inserttaphonomictype(
  _taphonomicsystemid integer,
  _taphonomictype character varying,
  _notes character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.taphonomictypes (taphonomicsystemid, taphonomictype, notes)
  VALUES (_taphonomicsystemid, _taphonomictype, _notes)
  RETURNING taphonomictypeid
$function$;
