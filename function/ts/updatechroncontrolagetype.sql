CREATE OR REPLACE FUNCTION ts.updatechroncontrolagetype(_chroncontrolid integer, _agetypeid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  UPDATE ndb.chroncontrols
  SET    agetypeid = _agetypeid
  WHERE  chroncontrolid = _chroncontrolid
$function$
