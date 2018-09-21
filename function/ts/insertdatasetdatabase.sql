CREATE OR REPLACE FUNCTION ts.insertdatasetdatabase(_datasetid integer, _databaseid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.datasetdatabases(datasetid, databaseid)
VALUES (_datasetid, _databaseid)
$function$;
