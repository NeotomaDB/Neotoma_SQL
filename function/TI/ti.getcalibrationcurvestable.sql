CREATE OR REPLACE FUNCTION ti.getcalibrationcurvestable()
RETURNS TABLE(calibrationcurveid int, calibrationcurve varchar(24), publicationid int) AS $$
SELECT calibrationcurveid, calibrationcurve, publicationid
FROM ndb.calibrationcurves;
$$ LANGUAGE SQL;