CREATE OR REPLACE FUNCTION ndb.rawbymonth(startperiod integer default 0,
                                                endperiod integer default 1)
RETURNS TABLE (datasets bigint,
               sites bigint,
             publications, bigint,
           authors bigint,
         observations bigint)
AS
$function$
WITH rsum AS (
  SELECT ds.datasetid,
        dsl.siteid,
        array_agg(DISTINCT dsp.publicationid) AS publications,
        array_agg(DISTINCT pua.contactid) AS authors,
        gpd.path[1] AS countrygpid,
        smp.observations
  FROM ndb.datasets AS ds
  JOIN ndb.datasetsubmissions AS dss on dss.datasetid = ds.datasetid
  JOIN ndb.dslinks AS dsl ON dsl.datasetid = ds.datasetid
  JOIN ndb.dssampdata AS smp ON ds.datasetid = smp.datasetid
  LEFT OUTER JOIN ndb.datasetpublications AS dsp ON dsp.datasetid = ds.datasetid
  LEFT OUTER JOIN ndb.publicationauthors AS pua ON dsp.publicationid = pua.publicationid
  JOIN ndb.sitegeopolitical AS sgp ON dsl.siteid = sgp.siteid
  JOIN ndb.geopoldepth AS gpd ON gpd.geopoliticalid = sgp.geopoliticalid
  WHERE
    ds.datasetid < 10
  GROUP BY ds.datasetid, dsl.siteid, dsl.siteid, gpd.path[1], smp.observations)
SELECT COUNT(DISTINCT datasetid) AS datasets,
       COUNT(DISTINCT siteid) AS sites,
       COUNT(DISTINCT unpublications) AS publications,
       COUNT(DISTINCT unauthors) AS authors,
       COUNT(DISTINCT countrygpid) AS countries,
       SUM(observations) AS observations
FROM rsum,
						unnest(authors) AS unauthors,
						unnest(publications) AS unpublications
$function$ LANGUAGE SQL;
