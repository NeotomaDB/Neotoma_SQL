CREATE OR REPLACE FUNCTION ti.getconstituentdatabasenamebyid(_databaseid integer)
 RETURNS TABLE(databasename character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.constituentdatabases.databasename
FROM ndb.constituentdatabases
WHERE ndb.constituentdatabases.databaseid = _databaseid;
$function$
