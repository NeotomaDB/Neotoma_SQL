CREATE OR REPLACE FUNCTION doi.datasetinfo(dsid integer)
RETURNS TABLE (datasetid integer, dataset json) AS
$function$
SELECT dts.datasetid,
       json_build_object('site', json_build_object('siteid', sts.siteid,
                          'sitename', sts.sitename,
                       'sitedescription', sts.sitedescription,
                           'sitenotes', sts.notes,
                           'geography', ST_AsGeoJSON(sts.geog,5,2),
                          'altitude', sts.altitude,
                      'collectionunitid', clu.collectionunitid,
                        'collectionunit', clu.collunitname,
                            'handle', clu.handle,
                          'unittype', cts.colltype),
       'dataset', json_build_object(  'datasetid', dts.datasetid,
                                'datasettype', dst.datasettype,
                                'datasetnotes', dts.notes,
                                'database', cstdb.databasename,
                                        'doi', doi.doi,
                                 'datasetpi', json_build_object('contactid', cnt.contactid,
                                                                'contactname', cnt.contactname,
                                                                'familyname', cnt.familyname,
                                                                'firstname', cnt.givennames,
                                                                'initials', cnt.leadinginitials),
                                 'agerange', json_build_object('ageyoung', agerange.younger,
                                                               'ageold', agerange.older,
                                                               'units', agetypes.agetype)))
FROM
ndb.datasets AS dts LEFT OUTER JOIN
ndb.collectionunits AS clu ON clu.collectionunitid = dts.collectionunitid LEFT OUTER JOIN
ndb.sites AS sts ON sts.siteid = clu.siteid  LEFT OUTER JOIN
ndb.datasettypes AS dst ON dst.datasettypeid = dts.datasettypeid LEFT OUTER JOIN
ndb.datasetdoi AS doi ON dts.datasetid = doi.datasetid LEFT OUTER JOIN
ndb.collectiontypes as cts ON clu.colltypeid = cts.colltypeid LEFT OUTER JOIN
ndb.datasetdatabases AS dsdb ON dsdb.datasetid = dts.datasetid LEFT OUTER JOIN
ndb.datasetpis AS dspi ON dspi.datasetid = dts.datasetid LEFT OUTER JOIN
ndb.contacts AS cnt ON cnt.contactid = dspi.contactid LEFT OUTER JOIN
ndb.dsageranges AS agerange ON dts.datasetid = agerange.datasetid LEFT OUTER JOIN
ndb.agetypes AS agetypes ON agetypes.agetypeid = agerange.agetypeid LEFT OUTER JOIN
ndb.constituentdatabases AS cstdb ON dsdb.databaseid = cstdb.databaseid WHERE
dts.datasetid = dsid
GROUP BY dts.datasetid, sts.siteid, clu.collectionunitid, cts.colltype;
$function$ LANGUAGE sql;
