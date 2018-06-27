CREATE OR REPLACE FUNCTION ap.gettaphonomicsystems(datasettypeid integer)
 RETURNS TABLE(taphonomicsystemid integer, taphonomicsystem character varying)
 LANGUAGE sql
AS $function$
SELECT ts.taphonomicsystemid, ts.taphonomicsystem
FROM ndb.taphonomicsystems AS ts INNER JOIN
ndb.taphonomicsystemsdatasettypes AS tsdt ON tsdt.taphonomicsystemid = ts.taphonomicsystemid
WHERE tsdt.datasettypeid = $1
ORDER BY taphonomicsystem
$function$
