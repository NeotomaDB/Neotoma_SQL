CREATE OR REPLACE FUNCTION ti.getcalibrationprogramstable()
 RETURNS TABLE(calibrationprogramid integer, calibrationprogram character varying, version character varying)
 LANGUAGE sql
AS $function$
SELECT calibrationprogramid, calibrationprogram, version
FROM ndb.calibrationprograms;
$function$
