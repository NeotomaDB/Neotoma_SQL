CREATE OR REPLACE FUNCTION doi.datasetinfo(dsid INT[])
    RETURNS TABLE(datasetid integer, dataset json)
    LANGUAGE sql
AS $function$

SELECT dts.datasetid,
       sts.site || jsonb_build_object('collectionunit', json_build_object('collectionunitid', clu.collectionunitid,
                                                                          'depositionalenvironment', dvt.depenvt,
                                                                                  'collectionunit', clu.collunitname,
                                                                                          'handle', clu.handle,
                                                                                    'collunittype', cts.colltype,
                                                                                    'colldate', clu.colldate,
                                                                                    'waterdepth', clu.waterdepth,
                                                                                    'notes', clu.notes,
                                                                                    'collectiondevice', clu.colldevice,
                                                                                    'gpslocation', json_build_object('latitude', clu.gpslatitude, 
                                                                                                                      'longitude', clu.gpslongitude, 
                                                                                                                      'gpsaltitude', clu.gpsaltitude, 
                                                                                                                      'gpserror', clu.gpserror),
                                                                                    'location', clu.location)
       json_build_object('site', json_build_object('siteid', sts.siteid,
                                                 'sitename', sts.sitename,
                                          'sitedescription', sts.sitedescription,
                                                'sitenotes', sts.notes,
                                                'geography', sts.geography,
                                                     'area', sts.area,
                                                 'altitude', sts.altitude,
                                             'geopolitical', sts.geopolitical,
                          'collectionunit', ,
							       'dataset', json_build_object(  'datasetid', dts.datasetid,
							                                    'datasettype', dst.datasettype,
							                                   'datasetnotes', dts.notes,
							                                       'database', cstdb.databasename,
							                                            'doi', doi.dois,
																                    'datasetpi', dsau.authors,
																                     'agerange', agerange.ages))))
FROM
         ndb.datasets AS dts
  LEFT OUTER JOIN ndb.collectionunits AS clu ON clu.collectionunitid = dts.collectionunitid
      LEFT OUTER JOIN ndb.depenvttypes AS dvt ON dvt.depenvtid = clu.depenvtid
             LEFT OUTER JOIN (SELECT * FROM ap.siteobject(clu.siteid)) AS sts ON sts.siteid = clu.siteid
      LEFT OUTER JOIN ndb.datasettypes AS dst ON dst.datasettypeid = dts.datasettypeid
   LEFT OUTER JOIN ndb.collectiontypes AS cts ON clu.colltypeid = cts.colltypeid
 LEFT OUTER JOIN ndb.datasetdatabases AS dsdb ON dsdb.datasetid = dts.datasetid
 LEFT OUTER JOIN ndb.collectors AS col ON col.collectionunitid = clu.collectionunitid
    LEFT OUTER JOIN (SELECT * FROM doi.agerange(dsid)) AS agerange ON agerange.datasetid = dts.datasetid
                LEFT OUTER JOIN ndb.constituentdatabases  AS cstdb ON dsdb.databaseid = cstdb.databaseid
     LEFT OUTER JOIN (SELECT * FROM doi.doireturn(dsid))  AS doi   ON doi.datasetid = dts.datasetid 
 LEFT OUTER JOIN (SELECT * FROM doi.datasetauthors(dsid)) AS dsau  ON dsau.datasetid = dts.datasetid
WHERE dts.datasetid = ANY(dsid)

$function$;

CREATE OR REPLACE FUNCTION doi.datasetinfo(
	dsid integer)
    RETURNS TABLE(datasetid integer, dataset json)
    LANGUAGE 'sql'
AS $function$

SELECT dts.datasetid,
       ap.siteobject(clu.siteid) || 
       json_build_object('collectionunit', json_build_object('collectionunitid', clu.collectionunitid,
                                                       'depositionalenvironment', dvt.depenvt,
                                                                'collectionunit', clu.collunitname,
                                                                        'handle', clu.handle,
                                                                  'collunittype', cts.colltype,
                                                                      'colldate', clu.colldate,
                                                                    'waterdepth', clu.waterdepth,
                                                                         'notes', clu.notes,
                                                              'collectiondevice', clu.colldevice,
                                                                                    'gpslocation', json_build_object('latitude', clu.gpslatitude, 
                                                                                                                      'longitude', clu.gpslongitude, 
                                                                                                                      'gpsaltitude', clu.gpsaltitude, 
                                                                                                                      'gpserror', clu.gpserror),
                                                                                    'location', clu.location)
							       'dataset', json_build_object(  'datasetid', dts.datasetid,
							                                    'datasettype', dst.datasettype,
							                                   'datasetnotes', dts.notes,
							                                       'database', cstdb.databasename,
							                                            'doi', doi.dois,
																                    'datasetpi', dsau.authors,
																                     'agerange', agerange.ages))
FROM
ndb.datasets AS dts LEFT OUTER JOIN
ndb.collectionunits AS clu ON clu.collectionunitid = dts.collectionunitid LEFT OUTER JOIN
     ndb.depenvttypes AS dvt ON dvt.depenvtid = clu.depenvtid LEFT OUTER JOIN
ndb.datasettypes AS dst ON dst.datasettypeid = dts.datasettypeid LEFT OUTER JOIN
ndb.collectiontypes as cts ON clu.colltypeid = cts.colltypeid LEFT OUTER JOIN
ndb.datasetdatabases AS dsdb ON dsdb.datasetid = dts.datasetid LEFT OUTER JOIN
(SELECT * FROM doi.agerange(dsid)) AS agerange ON agerange.datasetid = dts.datasetid LEFT OUTER JOIN
ndb.constituentdatabases AS cstdb ON dsdb.databaseid = cstdb.databaseid LEFT OUTER JOIN
(SELECT * FROM doi.doireturn(dsid)) AS doi ON doi.datasetid = dts.datasetid LEFT OUTER JOIN
(SELECT * FROM doi.datasetauthors(dsid)) AS dsau ON dsau.datasetid = dts.datasetid
WHERE dts.datasetid = dsid

$function$;
