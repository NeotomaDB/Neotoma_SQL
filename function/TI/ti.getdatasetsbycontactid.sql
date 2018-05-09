CREATE OR REPLACE FUNCTION ti.getdatasetsbycontactid(_contactid int)
RETURNS TABLE(datasetid int, datasettype varchar(64), siteid int, sitename varchar(128), geopolname1 varchar(255),
		geopolname2 varchar(255), geopolname3 varchar(255))
AS $$
SELECT ndb.datasetpis.datasetid, ndb.datasettypes.datasettype, ndb.sites.siteid, ndb.sites.sitename, ti.geopol1.geopolname1, 
          ti.geopol2.geopolname2, ti.geopol3.geopolname3
FROM ndb.datasetpis INNER JOIN
     ndb.datasets ON ndb.datasetpis.datasetid = ndb.datasets.datasetid INNER JOIN
     ndb.collectionunits ON ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid INNER JOIN
     ndb.sites ON ndb.collectionunits.siteid = ndb.sites.siteid INNER JOIN
     ndb.datasettypes ON ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid LEFT OUTER JOIN
     ti.geopol3 ON ndb.sites.siteid = ti.geopol3.siteid LEFT OUTER JOIN
     ti.geopol2 ON ndb.sites.siteid = ti.geopol2.siteid LEFT OUTER JOIN
     ti.geopol1 ON ndb.sites.siteid = ti.geopol1.siteid
WHERE ndb.datasetpis.contactid = _contactid
ORDER BY ndb.sites.sitename;
$$ LANGUAGE SQL;