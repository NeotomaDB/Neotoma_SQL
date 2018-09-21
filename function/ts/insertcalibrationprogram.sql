CREATE OR REPLACE FUNCTION ts.insertcalibrationprogram(_calibrationprogram character varying, _version character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.calibrationprograms (calibrationprogram, version)
VALUES (_calibrationprogram, _version)
$function$;
---return id
select scope_identity()
