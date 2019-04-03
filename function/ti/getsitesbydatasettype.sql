CREATE OR REPLACE FUNCTION ti.getsitesbydatasettype(datasettypeid integer)
 RETURNS TABLE(siteid integer,
               sitename character varying,
               latitude double precision,
               longitude double precision,
               altitude double precision,
               area double precision)
 LANGUAGE sql
AS $function$
SELECT
  sts.siteid AS siteid,
  sts.sitename AS sitename,
  ST_Y(ST_CENTROID(sts.geog)) AS latitude,
  ST_X(ST_CENTROID(sts.geog)) AS longitude, 
  sts.altitude,
  sts.area
FROM ndb.datasets AS ds
  INNER JOIN ndb.dslinks AS scd ON ds.collectionunitid = scd.collectionunitid
  INNER JOIN ndb.sites AS sts ON scd.siteid = sts.siteid
WHERE datasettypeid = ds.datasettypeid
GROUP BY sts.siteid
$function$
