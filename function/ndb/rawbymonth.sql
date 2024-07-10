CREATE OR REPLACE FUNCTION ndb.rawbymonth(startperiod integer DEFAULT 0, endperiod integer DEFAULT 1)
 RETURNS TABLE(datasets bigint, sites bigint, publications bigint, authors bigint, countrygpid bigint, observations numeric)
 LANGUAGE sql
AS $function$
WITH rsum AS (
  SELECT ds.datasetid,
         tb.siteid,
         array_agg(DISTINCT dsp.publicationid) AS publications,
         array_agg(DISTINCT pua.contactid) AS authors,
         gpd.path[1] AS countrygpid
  FROM ndb.datasets AS ds
  JOIN ndb.datasetsubmissions AS dss on dss.datasetid = ds.datasetid
  JOIN ndb.dslinks AS dsl ON dsl.datasetid = ds.datasetid
  LEFT OUTER JOIN ndb.datasetpublications AS dsp ON dsp.datasetid = ds.datasetid
  LEFT OUTER JOIN ndb.publicationauthors AS pua ON dsp.publicationid = pua.publicationid
  JOIN ndb.sitegeopolitical AS sgp ON dsl.siteid = sgp.siteid
  JOIN ndb.geopoldepth AS gpd ON gpd.geopoliticalid = sgp.geopoliticalid
  WHERE
  EXTRACT(year from AGE(NOW(), dss.submissiondate))*12 +
  EXTRACT(month from AGE(NOW(), dss.submissiondate)) BETWEEN startperiod and endperiod
  GROUP BY ds.datasetid, dsl.siteid, gpd.path[1]),
shortsum AS (
  SELECT COUNT(DISTINCT datasetid) AS datasets,
         COUNT(DISTINCT siteid) AS sites,
         COUNT(DISTINCT unpublications) AS publications,
         COUNT(DISTINCT unauthors) AS authors,
         COUNT(DISTINCT countrygpid) AS countries
  FROM rsum,
  		 unnest(authors) AS unauthors,
  		 unnest(publications) AS unpublications),
obssum AS (
   SELECT ds.datasetid, MAX(dsm.observations) AS observations
   FROM ndb.datasets AS ds
   JOIN ndb.datasetsubmissions AS dss on dss.datasetid = ds.datasetid
   JOIN ndb.dssampdata AS dsm ON dsm.datasetid = ds.datasetid
   WHERE
    EXTRACT(year from AGE(NOW(), dss.submissiondate))*12 +
    EXTRACT(month from AGE(NOW(), dss.submissiondate))
    BETWEEN startperiod and endperiod
  GROUP BY ds.datasetid
)
SELECT *,
      (SELECT SUM(observations) FROM obssum) AS observations
FROM shortsum

$function$
