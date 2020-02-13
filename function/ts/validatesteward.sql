CREATE OR REPLACE FUNCTION ts.validatesteward(_username character varying, _pwd character varying)
	RETURNS TABLE (databaseid INTEGER)
	LANGUAGE sql
AS $function$
	SELECT cds.databaseid
	FROM  ti.stewards AS ss
				JOIN  ti.stewarddatabases AS sds on ss.stewardid = sds.stewardid
				join ndb.constituentdatabases AS cds on sds.databaseid = cds.databaseid
	WHERE ss.username = _username AND ss.pwd = _pwd
$function$;
