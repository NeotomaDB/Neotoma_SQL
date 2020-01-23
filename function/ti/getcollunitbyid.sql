CREATE OR REPLACE FUNCTION ti.getcollunitbyid(_collectionunitid integer)
 RETURNS TABLE(collectionunitid integer,
               handle character varying,
               siteid integer,
               colltypeid integer,
               depenvtid integer,
               collunitname character varying,
               colldate character varying,
               colldevice character varying,
               gpslatitude double precision,
               gpslongitude double precision,
               gpsaltitude double precision,
               gpserror double precision,
               waterdepth double precision,
               substrateid integer,
               slopeaspect integer,
               slopeangle integer,
               location character varying,
               notes text)
 LANGUAGE sql
AS $function$
  SELECT cu.collectionunitid,
         cu.handle, cu.siteid, cu.colltypeid,
         cu.depenvtid, cu.collunitname,
         cu.colldate::varchar(10) AS colldate,
         cu.colldevice, cu.gpslatitude,
         cu.gpslongitude, cu.gpsaltitude,
		     cu.gpserror, cu.waterdepth,
         cu.substrateid, cu.slopeaspect, cu.slopeangle,
         cu.location, cu.notes
	FROM ndb.collectionunits AS cu
	WHERE cu.collectionunitid = _collectionunitid;
$function$
