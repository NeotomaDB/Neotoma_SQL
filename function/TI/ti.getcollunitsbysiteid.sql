CREATE OR REPLACE FUNCTION ti.getcollunitsbysiteid(_siteid int) RETURNS SETOF record
AS $$                                                                                
SELECT ndb.sites.siteid, ndb.collectionunits.collectionunitid, ndb.collectionunits.handle, ndb.collectionunits.siteid, ndb.collectionunits.colltypeid, 
       ndb.collectionunits.depenvtid, ndb.collectionunits.collunitname, ndb.collectionunits.colldate::varchar(10) AS colldate, ndb.collectionunits.colldevice, ndb.collectionunits.gpslatitude, 
       ndb.collectionunits.gpslongitude, ndb.collectionunits.gpsaltitude, ndb.collectionunits.gpserror, ndb.collectionunits.waterdepth, 
       ndb.collectionunits.substrateid, ndb.collectionunits.slopeaspect, ndb.collectionunits.slopeangle, ndb.collectionunits.location, ndb.collectionunits.notes
FROM ndb.sites INNER JOIN ndb.collectionunits ON ndb.sites.siteid = ndb.collectionunits.siteid
WHERE ndb.sites.siteid = _siteid;
$$ LANGUAGE SQL;