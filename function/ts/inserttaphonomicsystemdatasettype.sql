CREATE OR REPLACE FUNCTION ts.inserttaphonomicsystemdatasettype(_datasettypeid integer, _taphonomicsystemid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.taphonomicsystemsdatasettypes
	  (datasettypeid, taphonomicsystemid)
  VALUES (_datasettypeid, _taphonomicsystemid)
$function$
