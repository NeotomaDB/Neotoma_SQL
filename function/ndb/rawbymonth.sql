CREATE OR REPLACE FUNCTION ndb.rawbymonth(startperiod integer default 0,
                                                endperiod integer default 1)
RETURNS TABLE (summary json)
AS
$function$
SELECT ds.datasetid,
        dsl.siteid,
        COUNT(DISTINCT(dsp.publicationid)) AS publications,
        COUNT(DISTINCT(pua.contactid)) AS authors,
        gpd.path[1] AS countrygpid,
        smp.observations
FROM ndb.datasets AS ds
JOIN ndb.datasetsubmissions AS dss on dss.datasetid = ds.datasetid
JOIN ndb.dslinks AS dsl ON dsl.datasetid = ds.datasetid
JOIN ndb.dsdampdata AS smp ON ds.datasetid = smp.datasetid
LEFT OUTER JOIN ndb.datasetpublications AS dsp ON dsp.datasetid = ds.datasetid
LEFT OUTER JOIN ndb.publicationauthors AS pua ON dsp.publicationid = pua.publicationid
JOIN ndb.sitegeopolitical AS sgp ON dsl.siteid = sgp.siteid
JOIN ndb.geopoldepth AS gpd ON gpd.geopoliticalid = sgp.geopoliticalid
WHERE
  EXTRACT(year from AGE(NOW(), dss.submissiondate))*12 +
   EXTRACT(month from AGE(NOW(), dss.submissiondate)) BETWEEN startperiod and endperiod
GROUP BY ds.datasetid, dsl.siteid, dsl.siteid, gpd.path[1], smp.observations
$function$ LANGUAGE SQL;
