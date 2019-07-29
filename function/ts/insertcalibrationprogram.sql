CREATE OR REPLACE FUNCTION ts.insertcalibrationprogram(_calibrationprogram character varying, _version character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.calibrationprograms (calibrationprogram, version)
  VALUES (_calibrationprogram, _version)
  RETURNING calibrationprogramid
$function$
