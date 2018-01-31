CREATE OR REPLACE FUNCTION ti.getcollunitbyid(int) RETURNS SETOF record
AS $$
SELECT collectionunitid, handle, siteid, colltypeid, depenvtid, collunitname, colldate::varchar(10) AS colldate, colldevice, gpslatitude, gpslongitude, gpsaltitude, 
       gpserror, waterdepth, substrateid, slopeaspect, slopeangle, location, notes
FROM ndb.collectionunits
WHERE collectionunitid = $1;
$$ LANGUAGE SQL;