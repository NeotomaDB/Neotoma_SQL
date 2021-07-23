-- 
DROP FUNCTION IF EXISTS ap.collectionunitobject(_collectionunitid integer);
CREATE OR REPLACE FUNCTION ap.collectionunitobject(_collectionunitid integer)
 RETURNS TABLE(collectionunitid integer, collectionunit jsonb)
 LANGUAGE sql
AS $function$
        SELECT clu.collectionunitid,
        jsonb_build_object('collectionunit', jsonb_build_object('collectionunitid', clu.collectionunitid,
                   'depositionalenvironment', dvt.depenvt,
                            'collectionunit', clu.collunitname,
                                    'handle', clu.handle,
                              'collunittype', cts.colltype,
                                  'colldate', clu.colldate,
                                'waterdepth', clu.waterdepth,
                                     'notes', clu.notes,
                          'collectiondevice', clu.colldevice,
                                  'location', clu.location,
                               'gpslocation', json_build_object('latitude', clu.gpslatitude, 
                                                               'longitude', clu.gpslongitude, 
                                                             'gpsaltitude', clu.gpsaltitude, 
                                                                'gpserror', clu.gpserror),
                            'collectors', json_agg(DISTINCT jsonb_build_object('contactid', cnt.contactid,
                                        'contactname', cnt.contactname,
                                        'familyname', cnt.familyname,
                                        'firstname', cnt.givennames,
                                        'initials', cnt.leadinginitials)))) AS collectionunit
    FROM
    ndb.collectionunits AS clu
    LEFT JOIN ndb.depenvttypes AS dvt ON dvt.depenvtid = clu.depenvtid
    LEFT JOIN ndb.collectiontypes AS cts ON cts.colltypeid = clu.colltypeid
    LEFT OUTER JOIN ndb.collectors AS col ON col.collectionunitid = clu.collectionunitid 
    LEFT JOIN ndb.contacts AS cnt ON cnt.contactid = col.contactid
    WHERE clu.collectionunitid = _collectionunitid
    GROUP BY clu.collectionunitid, dvt.depenvt, cts.colltype;
$function$;

COMMENT ON FUNCTION ap.collectionunitobject(_collectionunitid integer) IS 'Create the JSON object used to return relevant collectionunit metadata from a single collection unit id.';

DROP FUNCTION ap.collectionunitobject(_collectionunitid integer[]);
CREATE OR REPLACE FUNCTION ap.collectionunitobject(_collectionunitid integer[])
 RETURNS TABLE(collectionunitid integer, collectionunit jsonb)
 LANGUAGE sql
AS $function$
        SELECT clu.collectionunitid,
        jsonb_build_object('collectionunit', jsonb_build_object('collectionunitid', clu.collectionunitid,
                   'depositionalenvironment', dvt.depenvt,
                            'collectionunit', clu.collunitname,
                                    'handle', clu.handle,
                              'collunittype', cts.colltype,
                                  'colldate', clu.colldate,
                                'waterdepth', clu.waterdepth,
                                     'notes', clu.notes,
                          'collectiondevice', clu.colldevice,
                                  'location', clu.location,
                               'gpslocation', json_build_object('latitude', clu.gpslatitude, 
                                                               'longitude', clu.gpslongitude, 
                                                             'gpsaltitude', clu.gpsaltitude, 
                                                                'gpserror', clu.gpserror),
                            'collectors', json_agg(DISTINCT jsonb_build_object('contactid', cnt.contactid,
                                        'contactname', cnt.contactname,
                                        'familyname', cnt.familyname,
                                        'firstname', cnt.givennames,
                                        'initials', cnt.leadinginitials)))) AS collectionunit
    FROM
    ndb.collectionunits AS clu
    LEFT JOIN ndb.depenvttypes AS dvt ON dvt.depenvtid = clu.depenvtid
    LEFT JOIN ndb.collectiontypes AS cts ON cts.colltypeid = clu.colltypeid
    LEFT OUTER JOIN ndb.collectors AS col ON col.collectionunitid = clu.collectionunitid 
    LEFT JOIN ndb.contacts AS cnt ON cnt.contactid = col.contactid
    WHERE clu.collectionunitid = ANY(_collectionunitid)
    GROUP BY clu.collectionunitid, dvt.depenvt, cts.colltype
$function$;
COMMENT ON FUNCTION ap.collectionunitobject(_collectionunitid integer[]) IS 'Create the JSON object used to return relevant collectionunit metadata from an array of collection unit ids.';