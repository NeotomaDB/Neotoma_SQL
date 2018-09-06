CREATE OR REPLACE FUNCTION ti.getcontactdatasets(_contactid integer)
 RETURNS TABLE(contactid integer, datasettype character varying, sitename character varying, geopol1 character varying, geopol2 character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.datasetpis.contactid, ndb.datasettypes.datasettype, ndb.sites.sitename, ti.geopol1.geopolname1 as geopol1, 
       ti.geopol2.geopolname2 as geopol2
FROM ndb.datasets INNER JOIN
     ndb.datasetpis ON ndb.datasets.datasetid = ndb.datasetpis.datasetid INNER JOIN
     ndb.datasettypes ON ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid INNER JOIN
     ndb.collectionunits ON ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid INNER JOIN
     ndb.sites ON ndb.collectionunits.siteid = ndb.sites.siteid INNER JOIN
     ti.geopol1 ON ndb.sites.siteid = ti.geopol1.siteid LEFT OUTER JOIN
     ti.geopol2 ON ndb.sites.siteid = ti.geopol2.siteid
WHERE ndb.datasetpis.contactid = _contactid;
$function$
