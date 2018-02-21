CREATE OR REPLACE FUNCTION ti.getdatasetsampleanalysts(_datasetid int) RETURNS SETOF record
AS $$
SELECT ndb.sampleanalysts.sampleid, ndb.sampleanalysts.contactid
FROM ndb.samples INNER JOIN
     ndb.sampleanalysts ON ndb.samples.sampleid = ndb.sampleanalysts.sampleid
WHERE ndb.samples.datasetid = _datasetid;
$$ LANGUAGE SQL;