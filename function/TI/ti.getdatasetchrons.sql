CREATE OR REPLACE FUNCTION ti.getdatasetchrons(_datasetid int)
RETURNS TABLE(chronologyid int, chronologyname varchar(80), shortagetype varchar(32))
AS $$
SELECT ndb.chronologies.chronologyid, ndb.chronologies.chronologyname, ndb.agetypes.shortagetype
FROM ndb.datasets INNER JOIN
     ndb.chronologies ON ndb.datasets.collectionunitid = ndb.chronologies.collectionunitid INNER JOIN
     ndb.agetypes ON ndb.chronologies.agetypeid = ndb.agetypes.agetypeid
WHERE ndb.datasets.datasetid = _datasetid;
$$ LANGUAGE SQL;