CREATE OR REPLACE FUNCTION ti.gettaphonomictypesbysystem(_taphonomicsystemid integer)
 RETURNS TABLE(taphonomicsystemid integer, taphonomictypeid integer, taphonomictype character varying, notes character varying)
 LANGUAGE sql
AS $function$
select     tht.taphonomicsystemid,
            tht.taphonomictypeid,
			tht.taphonomictype,
			tht.notes
from         ndb.taphonomictypes AS tht
where     (taphonomicsystemid = _taphonomicsystemid)
$function$
