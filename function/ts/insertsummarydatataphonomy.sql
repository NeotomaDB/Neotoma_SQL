CREATE OR REPLACE FUNCTION ts.insertsummarydatataphonomy(
	_dataid integer,
	_taphonomictypeid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.summarydatataphonomy(dataid, taphonomictypeid)
  VALUES (_dataid, _taphonomictypeid)
$function$;
