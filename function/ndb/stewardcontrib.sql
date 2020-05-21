CREATE OR REPLACE FUNCTION ndb.stewardcontrib(startperiod integer DEFAULT 0, endperiod integer DEFAULT 1)
 RETURNS TABLE(databasename character varying, counts bigint)
 LANGUAGE sql
AS $function$
  SELECT cdb.databasename, count(*)
  FROM ndb.datasets AS ds
  JOIN ndb.datasetsubmissions AS dss on dss.datasetid = ds.datasetid
  JOIN ndb.constituentdatabases AS cdb ON cdb.databaseid = dss.databaseid
  WHERE EXTRACT(month from AGE(NOW(), dss.submissiondate)) BETWEEN startperiod and endperiod
  GROUP BY cdb.databasename
$function$
