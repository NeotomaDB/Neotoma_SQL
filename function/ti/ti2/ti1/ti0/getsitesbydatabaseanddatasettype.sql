CREATE OR REPLACE FUNCTION ti.getsitesbydatabaseanddatasettype(databaseid integer, datasettypeid integer)
 RETURNS TABLE(siteid integer, sitename character varying, latitude double precision, longitude double precision, altitude double precision, area double precision)
 LANGUAGE sql
AS $function$
SELECT
  sts.siteid AS siteid,
  sts.sitename AS sitename,
  ST_Y(ST_CENTROID(sts.geom)) AS latitude,
  ST_X(ST_CENTROID(sts.geom)) AS longitude,
  sts.altitude,
  sts.area
FROM ndb.datasets AS ds
  INNER JOIN ndb.dslinks AS scd ON ds.collectionunitid = scd.collectionunitid
  INNER JOIN   ndb.sites AS sts ON scd.siteid = sts.siteid
  INNER JOIN ndb.datasetdatabases AS dsdb ON ds.datasetid = dsdb.datasetid
WHERE datasettypeid = ds.datasettypeid
  AND databaseid = dsdb.databaseid
GROUP BY sts.siteid
$function$
