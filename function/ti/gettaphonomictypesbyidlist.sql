CREATE OR REPLACE FUNCTION ti.gettaphonomictypesbyidlist(_taphonomictypeids character varying)
 RETURNS TABLE(taphonomictypeid integer, taphonomictype character varying, taphonomicsystem character varying)
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
