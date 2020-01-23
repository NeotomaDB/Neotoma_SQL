CREATE OR REPLACE FUNCTION ti.getdatasetsbysiteid(_siteid integer)
 RETURNS TABLE(collectionunitid integer, collunitname character varying, datasetid integer, datasettype character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.collectionunits.collectionunitid, ndb.collectionunits.collunitname, ndb.datasets.datasetid, ndb.datasettypes.datasettype
FROM ndb.sites INNER JOIN ndb.collectionunits ON ndb.sites.siteid = ndb.collectionunits.siteid INNER JOIN
     ndb.datasets ON ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid INNER JOIN
     ndb.datasettypes ON ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid
WHERE ndb.sites.siteid = _siteid
$function$
