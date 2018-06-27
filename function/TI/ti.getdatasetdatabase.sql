CREATE OR REPLACE FUNCTION ti.getdatasetdatabase(_datasetid int)
RETURNS	TABLE(databaseid int, databasename varchar(80))
AS $$
SELECT ndb.constituentdatabases.databaseid, ndb.constituentdatabases.databasename
FROM ndb.datasets INNER JOIN
     ndb.datasetsubmissions ON ndb.datasets.datasetid = ndb.datasetsubmissions.datasetid INNER JOIN
     ndb.constituentdatabases ON ndb.datasetsubmissions.databaseid = ndb.constituentdatabases.databaseid
WHERE ndb.datasets.datasetid = _datasetid;
$$ LANGUAGE SQL;