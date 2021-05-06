CREATE OR REPLACE FUNCTION ts.updatechroncontrolageolder(_chroncontrolid integer, _agelimitolder double precision DEFAULT NULL::double precision)
 RETURNS void
 LANGUAGE sql
AS $function$
  UPDATE ndb.chroncontrols
  SET    agelimitolder = _agelimitolder
  WHERE  chroncontrolid = _chroncontrolid
$function$
