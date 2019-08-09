CREATE OR REPLACE FUNCTION ap.gettaphonomicsystems(datasettypeid int) RETURNS SETOF record
AS $$
SELECT ts.taphonomicsystemid, ts.taphonomicsystem
FROM ndb.taphonomicsystems AS ts INNER JOIN
ndb.taphonomicsystemsdatasettypes AS tsdt ON tsdt.taphonomicsystemid = ts.taphonomicsystemid
WHERE tsdt.datasettypeid = $1
ORDER BY taphonomicsystem
$$ LANGUAGE SQL;