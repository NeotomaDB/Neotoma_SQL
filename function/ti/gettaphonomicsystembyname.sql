CREATE OR REPLACE FUNCTION ti.gettaphonomicsystembyname(_taphonomicsystem character varying)
 RETURNS TABLE(taphonomicsystemid integer, taphonomicsystem character varying, notes character varying)
 LANGUAGE sql
AS $function$

 SELECT
	ts.taphonomicsystemid,
 	ts.taphonomicsystem,
    ts.notes
 FROM         ndb.taphonomicsystems AS ts
 WHERE    ts.taphonomicsystem ILIKE $1
$function$
