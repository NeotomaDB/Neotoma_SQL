CREATE OR REPLACE FUNCTION ti.getspecimendatecalbyspecimendateid(_specimendateid integer)
RETURNS TABLE(specimendatecalid INTEGER, calage DOUBLE PRECISION, calageolder DOUBLE PRECISION, calageyounger DOUBLE PRECISION, 
                      calibrationcurveid INTEGER, calibrationcurve CHARACTER VARYING, calibrationprogramid INTEGER, 
                      calibrationprogram CHARACTER VARYING, version CHARACTER VARYING)
LANGUAGE sql
AS $function$

SELECT 	ndb.specimendatescal.specimendatecalid, ndb.specimendatescal.calage, ndb.specimendatescal.calageolder, ndb.specimendatescal.calageyounger, 
                      ndb.specimendatescal.calibrationcurveid, ndb.calibrationcurves.calibrationcurve, ndb.specimendatescal.calibrationprogramid, 
                      ndb.calibrationprograms.calibrationprogram, ndb.calibrationprograms.version
FROM 	ndb.specimendatescal INNER JOIN 
		ndb.calibrationcurves ON ndb.specimendatescal.calibrationcurveid = ndb.calibrationcurves.calibrationcurveid INNER JOIN 
		ndb.calibrationprograms ON ndb.specimendatescal.calibrationprogramid = ndb.calibrationprograms.calibrationprogramid 
WHERE ndb.specimendatescal.specimendateid = $1 

$function$
