CREATE OR REPLACE FUNCTION ts.insertcollectionunit(_handle character varying, _siteid integer, _colltypeid integer DEFAULT NULL::integer, _depenvtid integer DEFAULT NULL::integer, _collunitname character varying DEFAULT NULL::character varying, _colldate date DEFAULT NULL::date, _colldevice character varying DEFAULT NULL::character varying, _gpslatitude double precision DEFAULT NULL::double precision, _gpslongitude double precision DEFAULT NULL::double precision, _gpsaltitude double precision DEFAULT NULL::double precision, _gpserror double precision DEFAULT NULL::double precision, _waterdepth double precision DEFAULT NULL::double precision, _watertabledepth double precision DEFAULT NULL::double precision, _substrateid integer DEFAULT NULL::integer, _slopeaspect integer DEFAULT NULL::integer, _slopeangle integer DEFAULT NULL::integer, _location character varying DEFAULT NULL::character varying, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$

  INSERT INTO ndb.collectionunits
                        (handle, siteid, colltypeid, depenvtid, collunitname, colldate, colldevice, gpslatitude, gpslongitude, gpsaltitude, gpserror, 
						 waterdepth, substrateid, slopeaspect, slopeangle, location, notes)
  VALUES      (_handle, _siteid, _colltypeid, _depenvtid, _collunitname, _colldate, _colldevice, _gpslatitude, _gpslongitude,
             _gpsaltitude, _gpserror, _waterdepth, _substrateid, _slopeaspect, _slopeangle, _location, _notes)

  RETURNING collectionunitid;

$function$
