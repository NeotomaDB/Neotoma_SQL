CREATE OR REPLACE FUNCTION ti.getchroncontrolsbychroncontrolid(_chroncontrolid integer)
RETURNS TABLE(chroncontrolid integer , chroncontroltypeid integer , chroncontroltype character varying(64), depth double precision, 
	thickness double precision, analysisunitid integer, analysisunitname character varying(80), agetypeid integer, age double precision, 
	agelimityounger double precision, agelimitolder double precision, notes text, calibrationcurve character varying(24), 
	calibrationprogram character varying(24), version character varying(24))
LANGUAGE sql
AS $function$
SELECT ndb.chroncontrols.chroncontrolid, ndb.chroncontrols.chroncontroltypeid, ndb.chroncontroltypes.chroncontroltype, ndb.chroncontrols.depth, 
	ndb.chroncontrols.thickness, ndb.chroncontrols.analysisunitid, ndb.analysisunits.analysisunitname, ndb.chroncontrols.agetypeid, ndb.chroncontrols.age, 
	ndb.chroncontrols.agelimityounger, ndb.chroncontrols.agelimitolder, ndb.chroncontrols.notes, ndb.calibrationcurves.calibrationcurve, 
	ndb.calibrationprograms.calibrationprogram, ndb.calibrationprograms.version
FROM ndb.calibrationprograms INNER JOIN
	ndb.chroncontrolscal14c ON ndb.calibrationprograms.calibrationprogramid = ndb.chroncontrolscal14c.calibrationprogramid INNER JOIN
	ndb.calibrationcurves ON ndb.chroncontrolscal14c.calibrationcurveid = ndb.calibrationcurves.calibrationcurveid RIGHT OUTER JOIN
	ndb.chroncontrols INNER JOIN
	ndb.chroncontroltypes ON ndb.chroncontrols.chroncontroltypeid = ndb.chroncontroltypes.chroncontroltypeid ON 
	ndb.chroncontrolscal14c.chroncontrolid = ndb.chroncontrols.chroncontrolid LEFT OUTER JOIN
	ndb.analysisunits ON ndb.chroncontrols.analysisunitid = ndb.analysisunits.analysisunitid
WHERE ndb.chroncontrols.chroncontrolid = $1;
$function$