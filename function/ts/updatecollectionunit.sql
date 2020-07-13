CREATE OR REPLACE FUNCTION ts.updatecollectionunit(
  _collunitid integer, _stewardcontactid integer,
  _handle character varying,
  _colltypeid integer DEFAULT NULL::integer,
  _depenvtid integer DEFAULT NULL::integer,
  _collunitname character varying DEFAULT NULL::character varying,
  _colldate date DEFAULT NULL::date, _colldevice character varying DEFAULT NULL::character varying,
  _gpslatitude double precision DEFAULT NULL::double precision,
   _gpslongitude double precision DEFAULT NULL::double precision,
   _gpsaltitude double precision DEFAULT NULL::double precision, 
   _gpserror double precision DEFAULT NULL::double precision,
   _waterdepth double precision DEFAULT NULL::double precision,
   _substrateid integer DEFAULT NULL::integer,
   _slopeaspect integer DEFAULT NULL::integer,
   _slopeangle integer DEFAULT NULL::integer,
    _location character varying DEFAULT NULL::character varying,
    _notes character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$

  WITH  collunit AS (
    SELECT * FROM ndb.collectionunits WHERE collectionunitid = _collunitid
  )
  UPDATE ndb.collectionunits
    SET
      handle = _handle,
      colltypeid = _colltypeid,
      depenvtid = _depenvtid,
      collunitname = _collunitname,
      colldate = _colldate,
      colldevice = _colldevice,
      gpslatitude = _gpslatitude,
      gpslongitude = _gpslongitude,
      gpsaltitude = _gpsaltitude,
      waterdepth = _waterdepth,
      substrateid = _substrateid,
      slopeaspect = _slopeaspect,
      slopeangle = _slopeangle,
      location = _location,
      notes = _notes
  WHERE collectionunitid = _collunitid;

$function$
