CREATE OR REPLACE FUNCTION ti.getdatasettypeshavingdata()
RETURNS TABLE(datasettypeid int, datasettype varchar(64))
AS $$
SELECT ndb.datasettypes.datasettypeid, ndb.datasettypes.datasettype
FROM ndb.datasettypes INNER JOIN
	ndb.datasets ON ndb.datasettypes.datasettypeid = ndb.datasets.datasettypeid
GROUP BY ndb.datasettypes.datasettypeid, ndb.datasettypes.datasettype
$$ LANGUAGE SQL;