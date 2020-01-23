CREATE OR REPLACE FUNCTION ts.insertspecimentaphonomy(_specimenid integer, _taphonomictypeid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.specimentaphonomy(specimenid, taphonomictypeid)
  VALUES      (_specimenid, _taphonomictypeid)
$function$
