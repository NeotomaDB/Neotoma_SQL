CREATE OR REPLACE FUNCTION ndb.datasetsummary(startperiod integer default 0,
                                                endperiod integer default 1)
RETURNS TABLE (databasename varchar,
               counts bigint)
AS
$function$
  SELECT dst.datasettype, count(*)
  FROM ndb.datasets AS ds
  JOIN ndb.datasettypes AS dst ON ds.datasettypeid = dst.datasettypeid
  JOIN ndb.datasetsubmissions AS dss on dss.datasetid = ds.datasetid
  JOIN ndb.constituentdatabases AS cdb ON cdb.databaseid = dss.databaseid
  WHERE EXTRACT(month from AGE(NOW(), dss.submissiondate)) BETWEEN 1 and 2
  GROUP BY cdb.databasename, dst.datasettype
$function$ LANGUAGE SQL;
