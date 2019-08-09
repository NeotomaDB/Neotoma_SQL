CREATE OR REPLACE FUNCTION ti.getdatasetidfordatasettypeidforgeochronanalunit(_geochronid int, _datasettypeid int)
RETURNS TABLE(datasetid INTEGER)
AS $$

SELECT ndb.datasets.datasetid
FROM   ndb.geochronology INNER JOIN
		ndb.samples ON ndb.geochronology.sampleid = ndb.samples.sampleid INNER JOIN
		ndb.analysisunits ON ndb.samples.analysisunitid = ndb.analysisunits.analysisunitid INNER JOIN
		ndb.datasets ON ndb.analysisunits.collectionunitid = ndb.datasets.collectionunitid
WHERE  (ndb.geochronology.geochronid = $1) AND (ndb.datasets.datasettypeid = $2)


$$ LANGUAGE SQL;