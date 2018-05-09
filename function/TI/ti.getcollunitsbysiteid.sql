CREATE OR REPLACE FUNCTION ti.getcollunitsbysiteid(_siteid int)
RETURNS TABLE(siteid int, collectionunitid int, handle varchar(10), siteid1 int, colltypeid int, depenvtid int, collunitname varchar(255), colldate varchar(10), 
		colldevice varchar(255), gpslatitude double precision, gpslongitude double precision, gpsaltitude double precision, gpserror double precision, waterdepth double precision, 
       	substrateid int, slopeaspect int, slopeangle int, location varchar(255), notes text)
AS $$                                                                                
SELECT ndb.sites.siteid, ndb.collectionunits.collectionunitid, ndb.collectionunits.handle, ndb.collectionunits.siteid, ndb.collectionunits.colltypeid, 
       ndb.collectionunits.depenvtid, ndb.collectionunits.collunitname, ndb.collectionunits.colldate::varchar(10) AS colldate, ndb.collectionunits.colldevice, ndb.collectionunits.gpslatitude, 
       ndb.collectionunits.gpslongitude, ndb.collectionunits.gpsaltitude, ndb.collectionunits.gpserror, ndb.collectionunits.waterdepth, 
       ndb.collectionunits.substrateid, ndb.collectionunits.slopeaspect, ndb.collectionunits.slopeangle, ndb.collectionunits.location, ndb.collectionunits.notes
FROM ndb.sites INNER JOIN ndb.collectionunits ON ndb.sites.siteid = ndb.collectionunits.siteid
WHERE ndb.sites.siteid = _siteid;
$$ LANGUAGE SQL;