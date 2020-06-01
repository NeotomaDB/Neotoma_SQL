CREATE OR REPLACE FUNCTION ts.updatecollectionunit(_collunitid integer, _stewardcontactid integer, _handle character varying, _colltypeid integer DEFAULT NULL::integer, _depenvtid integer DEFAULT NULL::integer, _collunitname character varying DEFAULT NULL::character varying, _colldate date DEFAULT NULL::date, _colldevice character varying DEFAULT NULL::character varying, _gpslatitude double precision DEFAULT NULL::double precision, _gpslongitude double precision DEFAULT NULL::double precision, _gpsaltitude double precision DEFAULT NULL::double precision, _gpserror double precision DEFAULT NULL::double precision, _waterdepth double precision DEFAULT NULL::double precision, _substrateid integer DEFAULT NULL::integer, _slopeaspect integer DEFAULT NULL::integer, _slopeangle integer DEFAULT NULL::integer, _location character varying DEFAULT NULL::character varying, _notes character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$

        WITH  collunit AS (
          SELECT * FROM ndb.collectionunits WHERE collectionunitid = _collunitid
        ),
        goods AS (
          SELECT True AS val
          UNION SELECT (_handle <> (SELECT handle FROM collunit) AND
            (_handle <> (SELECT handle FROM collunit)) IS NULL) AS val
          UNION SELECT (_colltypeid <> (SELECT colltypeid FROM collunit) AND
            (_colltypeid <> (SELECT colltypeid FROM collunit)) IS NULL) AS val
          UNION SELECT (_depenvtid <> (SELECT depenvtid FROM collunit) AND
            (_depenvtid <> (SELECT depenvtid FROM collunit)) IS NULL) AS val
          UNION SELECT (_collunitname <> (SELECT collunitname FROM collunit) AND
            (_collunitname <> (SELECT collunitname FROM collunit)) IS NULL) AS val
          UNION SELECT (_colldate <> (SELECT colldate FROM collunit) AND
            (_colldate <> (SELECT colldate FROM collunit)) IS NULL) AS val
          UNION SELECT (_colldevice <> (SELECT colldevice FROM collunit) AND
            (_colldevice <> (SELECT colldevice FROM collunit)) IS NULL) AS val
          UNION SELECT (_gpslatitude <> (SELECT gpslatitude FROM collunit) AND
            (_gpslatitude <> (SELECT gpslatitude FROM collunit)) IS NULL) AS val
          UNION SELECT (_gpslongitude <> (SELECT gpslongitude FROM collunit) AND
            (_gpslongitude <> (SELECT gpslongitude FROM collunit)) IS NULL) AS val
          UNION SELECT (_gpsaltitude <> (SELECT gpsaltitude FROM collunit) AND
            (_gpsaltitude <> (SELECT gpsaltitude FROM collunit)) IS NULL) AS val
          UNION SELECT (_waterdepth <> (SELECT waterdepth FROM collunit) AND
            (_waterdepth <> (SELECT waterdepth FROM collunit)) IS NULL) AS val
          UNION SELECT (_substrateid <> (SELECT substrateid FROM collunit) AND
            (_substrateid <> (SELECT substrateid FROM collunit)) IS NULL) AS val
          UNION SELECT (_slopeaspect <> (SELECT slopeaspect FROM collunit) AND
            (_slopeaspect <> (SELECT slopeaspect FROM collunit)) IS NULL) AS val
          UNION SELECT (_slopeangle <> (SELECT slopeangle FROM collunit) AND
            (_slopeangle <> (SELECT slopeangle FROM collunit)) IS NULL) AS val
          UNION SELECT (_location <> (SELECT location FROM collunit) AND
            (_location <> (SELECT location FROM collunit)) IS NULL) AS val
          UNION SELECT (_notes <> (SELECT notes FROM collunit) AND
            (_notes <> (SELECT notes FROM collunit)) IS NULL) AS val
        )

      insert into ti.stewardupdates(contactid, tablename, pk1, operation, columnname)
      SELECT _stewardcontactid,
             'collectionunits',
             _collunitid,
             'update',
             colnames
      FROM information_schema.columns AS colnames
	WHERE table_schema = 'ndb'
	  AND table_name   = 'collectionunits'
    AND (SELECT val FROM goods) IS True;

  UPDATE ndb.collectionunits
    SET
      handle = COALESCE(_handle, handle),
      colltypeid = COALESCE(_colltypeid, colltypeid),
      depenvtid = COALESCE(_depenvtid, depenvtid),
      collunitname = COALESCE(_collunitname, collunitname),
      colldate = COALESCE(_colldate, colldate),
      colldevice = COALESCE(_colldevice, colldevice),
      gpslatitude = COALESCE(_gpslatitude, gpslatitude),
      gpslongitude = COALESCE(_gpslongitude, gpslongitude),
      gpsaltitude = COALESCE(_gpsaltitude, gpsaltitude),
      waterdepth = COALESCE(_waterdepth, waterdepth),
      substrateid = COALESCE(_substrateid, substrateid),
      slopeaspect = COALESCE(_slopeaspect, slopeaspect),
      slopeangle = COALESCE(_slopeangle, slopeangle),
      location = COALESCE(_location, location),
      notes = COALESCE(_notes, notes)
  WHERE collectionunitid = _collunitid;

$function$
