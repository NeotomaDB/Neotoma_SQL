CREATE  OR REPLACE FUNCTION ts.upload(uploadobject jsonb)
RETURNS INTEGER
LANGUAGE pgsql
AS $function$
    /* YAML shows that we often first insert variables */
    siteid := (SELECT ts.insertsite(_sitename := (SELECT uploadobject #>> '{data,0,site,sitename}'),
                         _altitude := (SELECT uploadobject #> '{data,0,site,altitude}'),
                         _area := (SELECT uploadobject #> '{data,0,site,area}'),
                         _descript := (SELECT uploadobject #> '{data,0,site,sitedescription}'),
                         _notes := (SELECT uploadobject #> '{data,0,site,notes}')))
    /* SELECT ts.insertcontact() */
    /* YAML shows insert lake parameters */
    /* YAML shows insert sitegeopol */
    collinutid := SELECT ts.insertcollectionunit(_handle := (SELECT uploadobject #>> '{data,0,site,collectionunit, handle}'),
                                                 _siteid := siteid,
                                                 _colltypeid integer DEFAULT NULL::integer,
                                                 _depenvtid integer DEFAULT NULL::integer,
                                                 _collunitname character varying DEFAULT NULL::character varying,
                                                 _colldate date DEFAULT NULL::date,
                                                 _colldevice := (SELECT uploadobject #>> '{data,0,site,collectionunit, collectiondevice}'),
                                                 _gpslatitude double precision DEFAULT NULL::double precision,
                                                 _gpslongitude double precision DEFAULT NULL::double precision,
                                                 _gpsaltitude double precision DEFAULT NULL::double precision,
                                                 _gpserror double precision DEFAULT NULL::double precision,
                                                 _waterdepth := (SELECT uploadobject #>> '{data,0,site,collectionunit, waterdepth}'),
                                                 _watertabledepth double precision DEFAULT NULL::double precision,
                                                 _substrateid integer DEFAULT NULL::integer,
                                                 _slopeaspect integer DEFAULT NULL::integer,
                                                 _slopeangle integer DEFAULT NULL::integer,
                                                 _location := (SELECT uploadobject #>> '{data,0,site,collectionunit, location}'),
                                                 _notes  := (SELECT uploadobject #>> '{data,0,site,collectionunit, notes}'))
    /* Have to do this for the set of collectors */
    SELECT ts.insertcollector(_collunitid := collunitid, 
                              _contactid integer,
                              _collectororder integer)
    /* Add the set of analysis units */
    /* Add the set of chronologies */
    /* With the chronology id, add the chron controls */
    /* Add the dataset info */
    /* Link to the dataset database */
    /* Add the dataset PI info */
    /* Add the data processor info */
    /* Add dataset publication information */
    /* Add dataset repository information */
    /* Add any (dataset level) synonymys */
    /* Add samples */
    /* Add sample analyst */
    /* add sample age */
    /* Insert data */
    /* Insert dataset submission */
$function$