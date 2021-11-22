CREATE OR REPLACE FUNCTION doi.datasetinfo(dsid INT[])
    RETURNS TABLE(datasetid integer, site jsonb)
    LANGUAGE sql
AS $function$
WITH siteid AS (
    SELECT clu.siteid AS siteid
    FROM
         ndb.datasets AS dts
    LEFT OUTER JOIN ndb.collectionunits AS clu ON clu.collectionunitid = dts.collectionunitid
    WHERE dts.datasetid = ANY(dsid)
),
siteobj AS (
    SELECT * 
    FROM
        ap.siteobject((SELECT siteid FROM siteid))
)
SELECT dts.datasetid,
       sts.site || 
       jsonb_build_object('collectionunit', json_build_object('collectionunitid', clu.collectionunitid,
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
                                                                                                    'gpserror', clu.gpserror)),
						  'dataset', json_build_object('datasetid', dts.datasetid,
							                         'datasettype', dst.datasettype,
							                         'datasetname', dts.datasetname,
                                                    'datasetnotes', dts.notes,
							                            'database', cstdb.databasename,
							                                 'doi', doi.dois,
													   'datasetpi', dsau.authors,
														'agerange', agerange.ages))
FROM
         ndb.datasets AS dts
  LEFT OUTER JOIN                      ndb.collectionunits AS clu      ON clu.collectionunitid = dts.collectionunitid
  LEFT OUTER JOIN                         ndb.depenvttypes AS dvt      ON dvt.depenvtid = clu.depenvtid
  LEFT OUTER JOIN                                  siteobj AS sts      ON sts.siteid = clu.siteid
  LEFT OUTER JOIN                         ndb.datasettypes AS dst      ON dst.datasettypeid = dts.datasettypeid
  LEFT OUTER JOIN                      ndb.collectiontypes AS cts      ON clu.colltypeid = cts.colltypeid
  LEFT OUTER JOIN                     ndb.datasetdatabases AS dsdb     ON dsdb.datasetid = dts.datasetid
  LEFT OUTER JOIN                           ndb.collectors AS col      ON col.collectionunitid = clu.collectionunitid
  LEFT OUTER JOIN       (SELECT * FROM doi.agerange(dsid)) AS agerange ON agerange.datasetid = dts.datasetid
  LEFT OUTER JOIN                ndb.constituentdatabases  AS cstdb    ON dsdb.databaseid = cstdb.databaseid
  LEFT OUTER JOIN     (SELECT * FROM doi.doireturn(dsid))  AS doi      ON doi.datasetid = dts.datasetid 
  LEFT OUTER JOIN (SELECT * FROM doi.datasetauthors(dsid)) AS dsau     ON dsau.datasetid = dts.datasetid
WHERE dts.datasetid = ANY(dsid)

$function$;


CREATE OR REPLACE FUNCTION doi.datasetinfo(
	dsid integer)
    RETURNS TABLE(datasetid integer, site jsonb)
    LANGUAGE 'sql'
AS $function$
WITH siteid AS (
    SELECT clu.siteid AS siteid
    FROM
         ndb.datasets AS dts
    LEFT OUTER JOIN ndb.collectionunits AS clu ON clu.collectionunitid = dts.collectionunitid
    WHERE dts.datasetid = dsid
),
siteobj AS (
    SELECT * 
    FROM
        ap.siteobject((SELECT siteid FROM siteid))
)
SELECT dts.datasetid,
       sts.site || 
       jsonb_build_object('collectionunit', json_build_object('collectionunitid', clu.collectionunitid,
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
                                                                                    'location', clu.location),
							       'dataset', json_build_object(  'datasetid', dts.datasetid,
							                                    'datasettype', dst.datasettype,
                                                                'datasetname', dts.datasetname,
							                                   'datasetnotes', dts.notes,
							                                       'database', cstdb.databasename,
							                                            'doi', doi.dois,
																                    'datasetpi', dsau.authors,
																                     'agerange', agerange.ages))
FROM
ndb.datasets AS dts LEFT OUTER JOIN
ndb.collectionunits AS clu ON clu.collectionunitid = dts.collectionunitid LEFT OUTER JOIN
siteobj AS sts ON sts.siteid = clu.siteid LEFT OUTER JOIN
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
