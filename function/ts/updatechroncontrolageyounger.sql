CREATE OR REPLACE FUNCTION ts.updatechroncontrolageyounger(_chroncontrolid integer, _ageyounger double precision DEFAULT NULL::double precision)
 RETURNS void
 LANGUAGE sql
AS $function$
  UPDATE ndb.chroncontrols
  SET    agelimityounger = _ageyounger
  WHERE  chroncontrolid = _chroncontrolid
$function$
