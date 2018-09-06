CREATE OR REPLACE FUNCTION ti.gettaphonomicsystemsdatasettypestable()
 RETURNS TABLE(datasettypeid integer, taphonomicsystemid integer)
 LANGUAGE sql
AS $function$
SELECT datasettypeid, 
       taphonomicsystemid
 FROM ndb.taphonomicsystemsdatasettypes;
$function$
