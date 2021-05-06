CREATE OR REPLACE FUNCTION ts.updatechroncontrolage(_chroncontrolid integer, _age double precision DEFAULT NULL::double precision)
 RETURNS void
 LANGUAGE sql
AS $function$
  UPDATE ndb.chroncontrols
  SET    age = _age
  WHERE  chroncontrolid = _chroncontrolid
$function$
