CREATE OR REPLACE FUNCTION ts.updatechroncontrolnotes(_chroncontrolid integer, _notes CHARACTER VARYING DEFAULT NULL)
 RETURNS void
 LANGUAGE sql
AS $function$
  UPDATE ndb.chroncontrols
  SET    notes = _notes
  WHERE  chroncontrolid = _chroncontrolid
$function$
