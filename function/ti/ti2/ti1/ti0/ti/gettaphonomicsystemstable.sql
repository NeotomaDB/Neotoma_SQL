CREATE OR REPLACE FUNCTION ti.gettaphonomicsystemstable()
 RETURNS TABLE(taphonomicsystemid integer, taphonomicsystem character varying, notes text)
 LANGUAGE sql
AS $function$
SELECT taphonomicsystemid, 
       taphonomicsystem, 
       notes
 FROM ndb.taphonomicsystems;
$function$
