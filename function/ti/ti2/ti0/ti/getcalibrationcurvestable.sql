CREATE OR REPLACE FUNCTION ti.getcalibrationcurvestable()
 RETURNS TABLE(calibrationcurveid integer, calibrationcurve character varying, publicationid integer)
 LANGUAGE sql
AS $function$
SELECT calibrationcurveid, calibrationcurve, publicationid
FROM ndb.calibrationcurves;
$function$
