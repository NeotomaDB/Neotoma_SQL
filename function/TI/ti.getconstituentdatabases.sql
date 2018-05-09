CREATE OR REPLACE FUNCTION ti.getconstituentdatabases()
RETURNS TABLE(databaseid int, databasename varchar(80))
AS $$
SELECT ndb.constituentdatabases.databaseid, ndb.constituentdatabases.databasename
FROM ndb.constituentdatabases;
$$ LANGUAGE SQL;