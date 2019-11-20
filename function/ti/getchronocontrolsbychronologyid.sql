CREATE OR REPLACE FUNCTION ti.getchronocontrolsbychronologyid(_chronologyid integer)
 RETURNS TABLE(chroncontrolid integer,
               chroncontroltypeid integer,
               chroncontroltype character varying,
               depth double precision,
               thickness double precision,
               analysisunitid integer,
               analysisunitname character varying,
               age double precision,
               agelimityounger double precision,
               agelimitolder double precision,
               agetypeid integer,
               notes text,
               calibrationcurve character varying,
               calibrationprogram character varying,
               version character varying)
AS $$
SELECT chco.chroncontrolid,
       chco.chroncontroltypeid,
       cct.chroncontroltype,
       chco.depth,
       chco.thickness,
       au.analysisunitid,
       au.analysisunitname,
       chco.age,
       chco.agelimityounger,
       chco.agelimitolder,
       chco.agetypeid,
       chco.notes,
       cc.calibrationcurve,
       cp.calibrationprogram,
       cp.version
FROM ndb.calibrationprograms AS cp
  INNER JOIN ndb.chroncontrolscal14c AS cccal ON cp.calibrationprogramid = cccal.calibrationprogramid
  INNER JOIN ndb.calibrationcurves AS cc ON cccal.calibrationcurveid = cc.calibrationcurveid
  RIGHT OUTER JOIN ndb.chroncontrols AS chco
  INNER JOIN ndb.chroncontroltypes AS cct ON chco.chroncontroltypeid = cct.chroncontroltypeid ON
     cccal.chroncontrolid = chco.chroncontrolid
  LEFT OUTER JOIN ndb.analysisunits AS au ON chco.analysisunitid = au.analysisunitid
  WHERE chco.chronologyid = $1;
$$ LANGUAGE SQL;
