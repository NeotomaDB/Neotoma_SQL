CREATE OR REPLACE FUNCTION ti.getdatasetspecimens(_datasetid int)
RETURNS TABLE(specimenid int, analysisunitname varchar(80), depth double precision, thickness double precision, 
		taxonname varchar(80), variableunits varchar(64), variablecontext varchar(64), elementtype varchar(64),
		symmetry varchar(24), portion varchar(48), maturity varchar(36), sex varchar(24),
		domesticstatus varchar(24), nisp double precision, preservative varchar(256), repository varchar(128),
		specimennr varchar(50), fieldnr varchar(50), arctosnr varchar(50), genbanknr varchar(50), notes text,
		geochrontype varchar(64), labnumber varchar(40), fraction varchar(80), age double precision, errorolder double precision,
		erroryounger double precision, infinite smallint, calageolder double precision, calageyounger double precision,
		calibrationcurve varchar(24), calibrationprogram varchar(24), version varchar(24))
AS $$ 
SELECT ndb.specimens.specimenid, ndb.analysisunits.analysisunitname, ndb.analysisunits.depth, ndb.analysisunits.thickness, 
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
WHERE ndb.datasets.datasetid = _datasetid
ORDER BY ndb.specimens.specimenid
$$ LANGUAGE SQL;