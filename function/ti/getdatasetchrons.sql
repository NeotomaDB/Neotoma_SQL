CREATE OR REPLACE FUNCTION ti.getdatasetchrons(_datasetid integer)
 RETURNS TABLE(chronologyid integer, chronologyname character varying, shortagetype character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.chronologies.chronologyid, ndb.chronologies.chronologyname, ndb.agetypes.shortagetype
FROM ndb.datasets INNER JOIN
     ndb.chronologies ON ndb.datasets.collectionunitid = ndb.chronologies.collectionunitid INNER JOIN
     ndb.agetypes ON ndb.chronologies.agetypeid = ndb.agetypes.agetypeid
WHERE ndb.datasets.datasetid = _datasetid;
$function$
