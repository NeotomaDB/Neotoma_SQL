CREATE OR REPLACE FUNCTION ndb.datasetcontribs(startperiod integer DEFAULT 0, endperiod integer DEFAULT 1)
 RETURNS TABLE(databasename character varying, counts bigint)
 LANGUAGE sql
AS $function$
  SELECT ct.contactname, count(*)
  FROM ndb.datasets AS ds
  JOIN ndb.datasetsubmissions AS dss ON dss.datasetid = ds.datasetid
  JOIN ndb.contacts AS ct ON ct.contactid = dss.contactid
  WHERE EXTRACT(year from AGE(NOW(), dss.submissiondate))*12 +
   EXTRACT(month from AGE(NOW(), dss.submissiondate)) BETWEEN startperiod and endperiod
  GROUP BY ct.contactname
$function$;