CREATE OR REPLACE FUNCTION doi.datasetinfo(dsid INT[])
    RETURNS TABLE(datasetid integer, dataset json)
    LANGUAGE sql
AS $function$

SELECT dts.datasetid,
       json_build_object('site', json_build_object('siteid', sts.siteid,
                                                 'sitename', sts.sitename,
                                  'depositionalenvironment', dvt.depenvt,
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
							                                            'doi', doi.dois,
																                    'datasetpi', dsau.authors,
																                      'agerange', agerange.ages))
FROM
         ndb.datasets AS dts LEFT OUTER JOIN
  ndb.collectionunits AS clu ON clu.collectionunitid = dts.collectionunitid LEFT OUTER JOIN
     ndb.depenvttypes AS dvt ON dvt.depenvtid = clu.depenvtid LEFT OUTER JOIN
            ndb.sites AS sts ON sts.siteid = clu.siteid  LEFT OUTER JOIN
     ndb.datasettypes AS dst ON dst.datasettypeid = dts.datasettypeid LEFT OUTER JOIN
  ndb.collectiontypes AS cts ON clu.colltypeid = cts.colltypeid LEFT OUTER JOIN
ndb.datasetdatabases AS dsdb ON dsdb.datasetid = dts.datasetid LEFT OUTER JOIN
   (SELECT * FROM doi.agerange(dsid)) AS agerange ON agerange.datasetid = dts.datasetid LEFT OUTER JOIN
               ndb.constituentdatabases  AS cstdb ON dsdb.databaseid = cstdb.databaseid LEFT OUTER JOIN
    (SELECT * FROM doi.doireturn(dsid))  AS doi   ON doi.datasetid = dts.datasetid LEFT OUTER JOIN
(SELECT * FROM doi.datasetauthors(dsid)) AS dsau  ON dsau.datasetid = dts.datasetid
WHERE dts.datasetid = ANY(dsid)

$function$;

CREATE OR REPLACE FUNCTION doi.datasetinfo(
	dsid integer)
    RETURNS TABLE(datasetid integer, dataset json)
    LANGUAGE 'sql'
AS $function$

SELECT dts.datasetid,
       json_build_object('site', json_build_object('siteid', sts.siteid,
                                                 'sitename', sts.sitename,
                                  'depositionalenvironment', dvt.depenvt,
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
							                                            'doi', doi.dois,
																                    'datasetpi', dsau.authors,
																                      'agerange', agerange.ages))
FROM
ndb.datasets AS dts LEFT OUTER JOIN
ndb.collectionunits AS clu ON clu.collectionunitid = dts.collectionunitid LEFT OUTER JOIN
     ndb.depenvttypes AS dvt ON dvt.depenvtid = clu.depenvtid LEFT OUTER JOIN
ndb.sites AS sts ON sts.siteid = clu.siteid  LEFT OUTER JOIN
ndb.datasettypes AS dst ON dst.datasettypeid = dts.datasettypeid LEFT OUTER JOIN
ndb.collectiontypes as cts ON clu.colltypeid = cts.colltypeid LEFT OUTER JOIN
ndb.datasetdatabases AS dsdb ON dsdb.datasetid = dts.datasetid LEFT OUTER JOIN
(SELECT * FROM doi.agerange(dsid)) AS agerange ON agerange.datasetid = dts.datasetid LEFT OUTER JOIN
ndb.constituentdatabases AS cstdb ON dsdb.databaseid = cstdb.databaseid LEFT OUTER JOIN
(SELECT * FROM doi.doireturn(dsid)) AS doi ON doi.datasetid = dts.datasetid LEFT OUTER JOIN
(SELECT * FROM doi.datasetauthors(dsid)) AS dsau ON dsau.datasetid = dts.datasetid
WHERE dts.datasetid = dsid

$function$;
