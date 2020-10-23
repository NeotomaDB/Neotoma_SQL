CREATE OR REPLACE FUNCTION ts.updatechroncontrolagebasis(_chroncontrolid integer, _chroncontroltypeid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  UPDATE ndb.chroncontrols
  SET chroncontroltypeid = _chroncontroltypeid
  WHERE chroncontrolid = _chroncontrolid
$function$
