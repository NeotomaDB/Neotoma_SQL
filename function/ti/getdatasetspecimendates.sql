CREATE OR REPLACE FUNCTION ti.getdatasetspecimendates(_datasetid integer)
 RETURNS TABLE(specimenid integer, analysisunitname character varying, depth double precision, thickness double precision, taxonname character varying, variableunits character varying, variablecontext character varying, elementtype character varying, symmetry character varying, portion character varying, maturity character varying, sex character varying, domesticstatus character varying, nisp double precision, preservative character varying, repository character varying, specimennr character varying, fieldnr character varying, arctosnr character varying, genbanknr character varying, notes text, geochrontype character varying, labnumber character varying, fraction character varying, age double precision, errorolder double precision, erroryounger double precision, infinite boolean, calageolder double precision, calageyounger double precision, calibrationcurve character varying, calibrationprogram character varying, version character varying)
 LANGUAGE sql
AS $function$
SELECT 
                      ndb.specimens.specimenid, ndb.analysisunits.analysisunitname, ndb.analysisunits.depth, ndb.analysisunits.thickness,
                      ndb.taxa.taxonname, ndb.variableunits.variableunits, ndb.variablecontexts.variablecontext, ndb.elementtypes.elementtype,
                      ndb.elementsymmetries.symmetry, ndb.elementportions.portion, ndb.elementmaturities.maturity, ndb.specimensextypes.sex,
                      ndb.specimendomesticstatustypes.domesticstatus, ndb.specimens.nisp, ndb.specimens.preservative, ndb.repositoryinstitutions.repository,
                      ndb.specimens.specimennr, ndb.specimens.fieldnr, ndb.specimens.arctosnr, ndb.specimengenbank.genbanknr, ndb.specimens.notes,
                      ndb.geochrontypes.geochrontype, ndb.geochronology.labnumber, ndb.fractiondated.fraction, ndb.geochronology.age, ndb.geochronology.errorolder,
                      ndb.geochronology.erroryounger, ndb.geochronology.infinite, ndb.specimendatescal.calageolder, ndb.specimendatescal.calageyounger,
                      ndb.calibrationcurves.calibrationcurve, ndb.calibrationprograms.calibrationprogram, ndb.calibrationprograms.version
FROM ndb.specimengenbank RIGHT OUTER JOIN
                      ndb.datasets INNER JOIN
                      ndb.samples ON ndb.datasets.datasetid = ndb.samples.datasetid INNER JOIN
                      ndb.analysisunits ON ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid INNER JOIN
                      ndb.data ON ndb.samples.sampleid = ndb.data.sampleid INNER JOIN
                      ndb.specimens ON ndb.data.dataid = ndb.specimens.dataid INNER JOIN
                      ndb.variables ON ndb.data.variableid = ndb.variables.variableid INNER JOIN
                      ndb.taxa ON ndb.variables.taxonid = ndb.taxa.taxonid ON ndb.specimengenbank.specimenid = ndb.specimens.specimenid LEFT OUTER JOIN
                      ndb.calibrationcurves INNER JOIN
                      ndb.specimendatescal ON ndb.calibrationcurves.calibrationcurveid = ndb.specimendatescal.calibrationcurveid INNER JOIN
                      ndb.calibrationprograms ON ndb.specimendatescal.calibrationprogramid = ndb.calibrationprograms.calibrationprogramid RIGHT OUTER JOIN
                      ndb.geochrontypes INNER JOIN
                      ndb.geochronology ON ndb.geochrontypes.geochrontypeid = ndb.geochronology.geochrontypeid INNER JOIN
                      ndb.fractiondated INNER JOIN
                      ndb.specimendates ON ndb.fractiondated.fractionid = ndb.specimendates.fractionid ON ndb.geochronology.geochronid = ndb.specimendates.geochronid ON 
                      ndb.specimendatescal.specimendateid = ndb.specimendates.specimendateid ON 
                      ndb.specimens.specimenid = ndb.specimendates.specimenid LEFT OUTER JOIN
                      ndb.repositoryinstitutions ON ndb.specimens.repositoryid = ndb.repositoryinstitutions.repositoryid LEFT OUTER JOIN
                      ndb.specimendomesticstatustypes ON ndb.specimens.domesticstatusid = ndb.specimendomesticstatustypes.domesticstatusid LEFT OUTER JOIN
                      ndb.specimensextypes ON ndb.specimens.sexid = ndb.specimensextypes.sexid LEFT OUTER JOIN
                      ndb.elementsymmetries ON ndb.specimens.symmetryid = ndb.elementsymmetries.symmetryid LEFT OUTER JOIN
                      ndb.elementmaturities ON ndb.specimens.maturityid = ndb.elementmaturities.maturityid LEFT OUTER JOIN
                      ndb.elementportions ON ndb.specimens.portionid = ndb.elementportions.portionid LEFT OUTER JOIN
                      ndb.elementtypes ON ndb.specimens.elementtypeid = ndb.elementtypes.elementtypeid LEFT OUTER JOIN
                      ndb.variablecontexts ON ndb.variables.variablecontextid = ndb.variablecontexts.variablecontextid LEFT OUTER JOIN
                      ndb.variableunits ON ndb.variables.variableunitsid = ndb.variableunits.variableunitsid
WHERE (ndb.datasets.datasetid = _datasetid)
ORDER BY ndb.specimens.specimenid;
$function$
