CREATE OR REPLACE FUNCTION ap.sitelink(_siteid integer)
 RETURNS TABLE(siteid integer, sitelink jsonb)
 LANGUAGE sql
AS $function$
   SELECT sts.siteid,
    jsonb_build_object('collectionunitid', clu.collectionunitid,
                      'collectionunit', clu.collunitname,
                      'handle', clu.handle,
                      'collectionunittype', cts.colltype,
                      'datasets', json_agg(json_build_object('datasetid', dts.datasetid,
                                                             'datasettype', dst.datasettype))) AS collectionunit
  FROM
   ndb.datasets AS dts
    LEFT JOIN ndb.collectionunits AS clu ON clu.collectionunitid = dts.collectionunitid
    LEFT JOIN ndb.sites AS sts ON sts.siteid = clu.siteid
    LEFT JOIN ndb.datasettypes AS dst ON dst.datasettypeid = dts.datasettypeid
    LEFT OUTER JOIN ndb.collectiontypes as cts ON clu.colltypeid = cts.colltypeid
      WHERE sts.siteid = _siteid
  GROUP BY sts.siteid, clu.collectionunitid, cts.colltype
 $function$
