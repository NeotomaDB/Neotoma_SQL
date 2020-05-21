CREATE OR REPLACE FUNCTION ti.getspecimendatecalbyspecimendateid(_specimendateid integer)
 RETURNS TABLE(specimendatecalid integer, calage double precision, calageolder double precision, calageyounger double precision, calibrationcurveid integer, calibrationcurve character varying, calibrationprogramid integer, calibrationprogram character varying, version character varying)
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
