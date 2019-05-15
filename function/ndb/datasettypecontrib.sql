CREATE OR REPLACE FUNCTION ndb.datasettypecontrib(startperiod integer default 0,
                                                  endperiod integer default 1)
RETURNS TABLE (datasettype varchar,
               counts bigint)
AS
$function$
  SELECT dst.datasettype,
         count(DISTINCT ds.datasetid) AS count
  FROM ndb.datasets           AS ds
  JOIN ndb.datasettypes       AS dst ON dst.datasettypeid = ds.datasettypeid
  JOIN ndb.datasetsubmissions AS dss ON     dss.datasetid = ds.datasetid
  WHERE EXTRACT(year from AGE(NOW(), dss.submissiondate))*12 +
   EXTRACT(month from AGE(NOW(), dss.submissiondate)) BETWEEN startperiod and endperiod
  GROUP BY dst.datasettype
$function$ LANGUAGE SQL;
