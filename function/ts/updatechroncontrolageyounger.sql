CREATE OR REPLACE FUNCTION ts.updatechroncontrolageyounger(_chroncontrolid integer, _ageyounger float DEFAULT NULL)
 RETURNS void
 LANGUAGE sql
AS $function$
  UPDATE ndb.chroncontrols
  SET    agelimityounger = _ageyounger
  WHERE  chroncontrolid = _chroncontrolid
$function$
