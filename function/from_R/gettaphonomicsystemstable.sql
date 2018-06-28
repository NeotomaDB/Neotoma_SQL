CREATE OR REPLACE FUNCTION ti.gettaphonomicsystemstable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT    ndb.taphonomicsystems.taphonomicsystemid, ndb.taphonomicsystems.taphonomicsystem, ndb.taphonomicsystems.notes
 FROM ndb.taphonomicsystems;
$function$