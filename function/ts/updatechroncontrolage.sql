CREATE OR REPLACE FUNCTION ts.updatechroncontrolage(_chroncontrolid integer, _age float DEFAULT NULL)
 RETURNS void
 LANGUAGE sql
AS $function$
  UPDATE ndb.chroncontrols
  SET    age = _age
  WHERE  chroncontrolid = _chroncontrolid
$function$
