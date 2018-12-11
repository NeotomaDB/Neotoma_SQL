CREATE OR REPLACE FUNCTION gettaphonomictypesbyidlist (
  _taphonomictypeids CHARACTER VARYING)
RETURNS TABLE(
  taphonomictypeid INTEGER,
  taphonomictype CHARACTER VARYING,
  taphonomicsystem CHARACTER VARYING)
  LANGUAGE sql
AS $function$
SELECT
  tty.taphonomictypeid,
  tty.taphonomictype,
  ts.taphonomicsystem
FROM
  ndb.taphonomictypes AS tty
  JOIN ndb.taphonomicsystems AS ts on tty.taphonomicsystemid = ts.taphonomicsystemid
WHERE tty.taphonomictypeid in (SELECT unnest(string_to_array(_taphonomictypeids,'$'))::int)
$function$
