CREATE OR REPLACE FUNCTION ap.getdatasettypes()
RETURNS TABLE(datasettype varchar(64), datasettypeid int)
AS $$
SELECT ndb.datasettypes.datasettype, ndb.datasets.datasettypeid
FROM ndb.datasets INNER JOIN
ndb.datasettypes ON ndb.datasettypes.datasettypeid = ndb.datasets.datasettypeid
GROUP BY ndb.datasettypes.datasettype, ndb.datasets.datasettypeid
ORDER BY ndb.datasettypes.datasettype
$$ LANGUAGE SQL;
