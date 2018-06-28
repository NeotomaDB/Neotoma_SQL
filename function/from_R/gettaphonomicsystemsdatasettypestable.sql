CREATE OR REPLACE FUNCTION ti.gettaphonomicsystemsdatasettypestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      ndb.taphonomicsystemsdatasettypes.datasettypeid, ndb.taphonomicsystemsdatasettypes.taphonomicsystemid
 FROM ndb.taphonomicsystemsdatasettypes;
$function$