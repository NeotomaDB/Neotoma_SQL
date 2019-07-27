CREATE OR REPLACE FUNCTION ti.gettaphonomicsystembydatasettype(_datasettypeid integer)
 RETURNS TABLE(taphonomicsystemid integer, taphonomicsystem character varying, notes character varying)
 LANGUAGE sql
AS $function$

 SELECT
 	tsy.taphonomicsystemid,
	tsy.taphonomicsystem,
	tsy.notes
 FROM         ndb.taphonomicsystemsdatasettypes AS tsd INNER JOIN
              ndb.taphonomicsystems AS tsy ON tsd.taphonomicsystemid = tsy.taphonomicsystemid
 WHERE     tsd.datasettypeid = _datasettypeid

$function$
