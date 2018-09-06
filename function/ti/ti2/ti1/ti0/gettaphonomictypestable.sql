CREATE OR REPLACE FUNCTION ti.gettaphonomictypestable()
 RETURNS TABLE(taphonomictypeid integer, taphonomicsystemid integer, taphonomictype character varying, notes text)
 LANGUAGE sql
AS $function$
SELECT taphonomictypeid, 
     taphonomicsystemid,
         taphonomictype,
                  notes 
 FROM ndb.taphonomictypes;
$function$
