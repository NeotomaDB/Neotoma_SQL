CREATE OR REPLACE FUNCTION ti.getcollunitbyidv2(_collectionunitid integer)
 RETURNS TABLE(collectionunitid integer, handle character varying, siteid integer, colltypeid integer, depenvtid integer, collunitname character varying, colldate character varying, colldevice character varying, gpslatitude double precision, gpslongitude double precision, gpsaltitude double precision, gpserror double precision, waterdepth double precision, substrateid integer, slopeaspect integer, slopeangle integer, location character varying, notes text)
 LANGUAGE sql
AS $function$

SELECT collectionunitid, handle, siteid, colltypeid, depenvtid, collunitname, colldate::varchar(10) AS colldate, colldevice, gpslatitude, gpslongitude, gpsaltitude,
       gpserror, waterdepth, substrateid, slopeaspect, slopeangle, location, notes
FROM ndb.collectionunits
WHERE collectionunitid = $1;

$function$
