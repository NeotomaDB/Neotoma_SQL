CREATE OR REPLACE FUNCTION ti.getconstituentdatabases()
 RETURNS TABLE(databaseid integer, databasename character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.constituentdatabases.databaseid, ndb.constituentdatabases.databasename
FROM ndb.constituentdatabases;
$function$
