CREATE OR REPLACE FUNCTION ti.getgeochronanalysisunitsbydatasetid(_datasetid integer)
 RETURNS TABLE(sampleid integer, collectionunitid integer, analysisunitid integer, analysisunitname character varying, depth double precision, thickness double precision)
 LANGUAGE sql
AS $function$

SELECT ndb.samples.sampleid, ndb.analysisunits.collectionunitid, ndb.samples.analysisunitid, ndb.analysisunits.analysisunitname, ndb.analysisunits.depth,
	ndb.analysisunits.thickness
FROM ndb.datasets INNER JOIN
	ndb.samples ON ndb.datasets.datasetid = ndb.samples.datasetid INNER JOIN
	ndb.analysisunits ON ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid
WHERE ndb.datasets.datasetid = $1

$function$
