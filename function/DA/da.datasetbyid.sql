--this is part 2 of splitting original DA.ChronologyById  

CREATE OR REPLACE FUNCTION da.datasetbyid(dataid int) RETURNS SETOF record
AS $$
SELECT ndb.datasets.datasetid, ndb.datasettypes.datasettype
FROM ndb.chronologies INNER JOIN ndb.collectionunits ON ndb.chronologies.collectionunitid = ndb.collectionunits.collectionunitid INNER JOIN
	ndb.datasets ON ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid INNER JOIN
	ndb.datasettypes ON ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid INNER JOIN
	ndb.sampleages ON ndb.chronologies.chronologyid = ndb.sampleages.chronologyid INNER JOIN
	ndb.samples ON ndb.sampleages.sampleid = ndb.samples.sampleid AND ndb.datasets.datasetid = ndb.samples.datasetid
WHERE ndb.sampleages.chronologyid = dataid
GROUP BY ndb.datasets.datasetid, ndb.datasettypes.datasettype;
$$ LANGUAGE SQL;