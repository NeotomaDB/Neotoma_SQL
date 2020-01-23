CREATE OR REPLACE FUNCTION ndb.datasetconstitdb(startperiod integer default 0,
                                                endperiod integer default 1)
RETURNS TABLE (databasename varchar,
               counts bigint)
AS
$function$
  SELECT dst.datasettype, count(*)
  FROM ndb.datasets AS ds
  JOIN ndb.datasetsubmissions AS dss on dss.datasetid = ds.datasetid
  JOIN ndb.constituentdatabases AS cdb ON cdb.databaseid = dss.databaseid
  WHERE EXTRACT(month from AGE(NOW(), dss.submissiondate)) BETWEEN 1 and 2
  GROUP BY cdb.databasename
$function$ LANGUAGE SQL;
