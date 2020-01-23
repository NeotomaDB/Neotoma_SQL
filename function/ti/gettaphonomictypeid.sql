CREATE OR REPLACE FUNCTION ti.gettaphonomictypeid(_taphonomicsystemid integer, _taphonomictype character varying)
 RETURNS TABLE(taphonomictypeid integer)
 LANGUAGE sql
AS $function$
select     tt.taphonomictypeid
from         ndb.taphonomicsystems AS ts 

inner join ndb.taphonomictypes AS tt ON ts.taphonomicsystemid = tt.taphonomicsystemid
where     (ts.taphonomicsystemid = _taphonomicsystemid) and (tt.taphonomictype ILIKE _taphonomictype)

$function$
