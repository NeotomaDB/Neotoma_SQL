CREATE OR REPLACE FUNCTION ti.getdatasetsampledepagents(_datasetid int) RETURNS SETOF record
AS $$
SELECT ndb.samples.sampleid, ndb.depagenttypes.depagent
FROM ndb.depagents INNER JOIN
     ndb.samples ON ndb.depagents.analysisunitid = ndb.samples.analysisunitid INNER JOIN
     ndb.depagenttypes ON ndb.depagents.depagentid = ndb.depagenttypes.depagentid
WHERE ndb.samples.datasetid = _datasetid;
$$ LANGUAGE SQL;