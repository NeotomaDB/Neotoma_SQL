CREATE OR REPLACE FUNCTION ts.insertchroncontrolcal14c(_chroncontrolid integer, _calibrationcurveid integer, _calibrationprogramid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.chroncontrolscal14c(chroncontrolid, calibrationcurveid, calibrationprogramid)
VALUES (_chroncontrolid, _calibrationcurveid, _calibrationprogramid)
$function$;
