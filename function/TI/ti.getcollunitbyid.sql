CREATE OR REPLACE FUNCTION ti.getcollunitbyid(int)
RETURNS TABLE(collectionunitid int, handle varchar(10), siteid int, colltypeid int, depenvtid int, collunitname varchar(255),
		colldate varchar(10), colldevice varchar(255), gpslatitude double precision, gpslongitude double precision, gpsaltitude double precision, 
       gpserror double precision, waterdepth double precision, substrateid int, slopeaspect int, slopeangle int, location varchar(255), notes text)
AS $$
SELECT collectionunitid, handle, siteid, colltypeid, depenvtid, collunitname, colldate::varchar(10) AS colldate, colldevice, gpslatitude, gpslongitude, gpsaltitude, 
       gpserror, waterdepth, substrateid, slopeaspect, slopeangle, location, notes
FROM ndb.collectionunits
WHERE collectionunitid = $1;
$$ LANGUAGE SQL;