CREATE OR REPLACE FUNCTION ti.getdatasetsbysitename(_sitename character varying)
 RETURNS TABLE(siteid integer, sitename character varying, datasetid integer, datasettype character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.sites.siteid, ndb.sites.sitename, ndb.datasets.datasetid, ndb.datasettypes.datasettype
FROM ndb.sites INNER JOIN
     ndb.collectionunits ON ndb.sites.siteid = ndb.collectionunits.siteid INNER JOIN
     ndb.datasets ON ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid INNER JOIN
     ndb.datasettypes ON ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid
WHERE ndb.sites.sitename LIKE _sitename
$function$
