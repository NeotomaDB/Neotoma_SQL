CREATE OR REPLACE FUNCTION ti.getcollunitsbysiteid(_siteid integer)
 RETURNS TABLE(siteid integer, collectionunitid integer, handle character varying, siteid1 integer, colltypeid integer, depenvtid integer, collunitname character varying, colldate character varying, colldevice character varying, gpslatitude double precision, gpslongitude double precision, gpsaltitude double precision, gpserror double precision, waterdepth double precision, substrateid integer, slopeaspect integer, slopeangle integer, location character varying, notes text)
 LANGUAGE sql
AS $function$                                                                                
SELECT ndb.sites.siteid, ndb.collectionunits.collectionunitid, ndb.collectionunits.handle, ndb.collectionunits.siteid, ndb.collectionunits.colltypeid, 
       ndb.collectionunits.depenvtid, ndb.collectionunits.collunitname, ndb.collectionunits.colldate::varchar(10) AS colldate, ndb.collectionunits.colldevice, ndb.collectionunits.gpslatitude, 
       ndb.collectionunits.gpslongitude, ndb.collectionunits.gpsaltitude, ndb.collectionunits.gpserror, ndb.collectionunits.waterdepth, 
       ndb.collectionunits.substrateid, ndb.collectionunits.slopeaspect, ndb.collectionunits.slopeangle, ndb.collectionunits.location, ndb.collectionunits.notes
FROM ndb.sites INNER JOIN ndb.collectionunits ON ndb.sites.siteid = ndb.collectionunits.siteid
WHERE ndb.sites.siteid = _siteid;
$function$
