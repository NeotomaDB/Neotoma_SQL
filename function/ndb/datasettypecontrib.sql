CREATE OR REPLACE FUNCTION ndb.datasettypecontrib(startperiod integer DEFAULT 0, endperiod integer DEFAULT 1)
 RETURNS TABLE(datasettype character varying, counts bigint)
 LANGUAGE sql
AS $function$
  SELECT dst.datasettype, count(DISTINCT ds.datasetid)
  FROM ndb.datasets AS ds
  JOIN ndb.datasettypes AS dst ON dst.datasettypeid = ds.datasettypeid
  JOIN ndb.datasetsubmissions AS dss on dss.datasetid = ds.datasetid
  WHERE EXTRACT(year from AGE(NOW(), dss.submissiondate))*12 +
   EXTRACT(month from AGE(NOW(), dss.submissiondate)) BETWEEN startperiod and endperiod
  GROUP BY dst.datasettype
$function$;
