CREATE OR REPLACE FUNCTION ti.getconstituentdatabases() RETURNS SETOF record
AS $$
SELECT ndb.constituentdatabases.databaseid, ndb.constituentdatabases.databasename
FROM ndb.constituentdatabases;
$$ LANGUAGE SQL;