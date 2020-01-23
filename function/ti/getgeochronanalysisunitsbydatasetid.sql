CREATE OR REPLACE FUNCTION ti.getgeochronanalysisunitsbydatasetid(_datasetid int)
RETURNS TABLE(sampleid int, collectionunitid int, analysisunitid int, analysisunitname varchar(80), depth double precision, thickness double precision)
AS $$

SELECT ndb.samples.sampleid, ndb.analysisunits.collectionunitid, ndb.samples.analysisunitid, ndb.analysisunits.analysisunitname, ndb.analysisunits.depth,
	ndb.analysisunits.thickness
FROM ndb.datasets INNER JOIN
	ndb.samples ON ndb.datasets.datasetid = ndb.samples.datasetid INNER JOIN
	ndb.analysisunits ON ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
WHERE ndb.datasets.datasetid = $1

$$ LANGUAGE SQL;