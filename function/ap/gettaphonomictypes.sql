CREATE OR REPLACE FUNCTION ap.gettaphonomictypes(_taphonomicsystemid integer)
 RETURNS TABLE(taphonomictypeid integer, taphonomictype character varying)
 LANGUAGE sql
AS $function$
    select tt.taphonomictypeid, tt.taphonomictype
    from ndb.taphonomictypes as tt
    where tt.taphonomicsystemid = _taphonomicsystemid
    order by taphonomictype
$function$
