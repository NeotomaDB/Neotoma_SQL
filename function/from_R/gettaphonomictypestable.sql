CREATE OR REPLACE FUNCTION ti.gettaphonomictypestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      ndb.taphonomictypes.taphonomictypeid, ndb.taphonomictypes.taphonomicsystemid, ndb.taphonomictypes.taphonomictype, ndb.taphonomictypes.notes 
 FROM ndb.taphonomictypes;
$function$