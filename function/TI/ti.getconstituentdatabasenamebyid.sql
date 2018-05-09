CREATE OR REPLACE FUNCTION ti.getconstituentdatabasenamebyid(_databaseid int)
RETURNS TABLE(databasename varchar(80))
AS $$
SELECT ndb.constituentdatabases.databasename
FROM ndb.constituentdatabases
WHERE ndb.constituentdatabases.databaseid = _databaseid;
$$ LANGUAGE SQL;