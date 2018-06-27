CREATE OR REPLACE FUNCTION ti.getcalibrationprogramstable()
RETURNS TABLE(calibrationprogramid int, calibrationprogram varchar(24), version varchar(24)) AS $$
SELECT calibrationprogramid, calibrationprogram, version
FROM ndb.calibrationprograms;
$$ LANGUAGE SQL;