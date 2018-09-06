CREATE OR REPLACE FUNCTION ti.getstatscolltypedatasetcount()
 RETURNS TABLE(colltype character varying, datasetcount bigint)
 LANGUAGE sql
AS $function$
SELECT             ct.colltype AS colltype, 
           COUNT(ds.datasetid) AS datasets
FROM
  ndb.datasets AS ds
  INNER JOIN ndb.collectionunits AS cu on ds.collectionunitid = cu.collectionunitid 
  INNER JOIN ndb.collectiontypes AS ct on       cu.colltypeid = ct.colltypeid
GROUP BY ct.colltype
ORDER BY ct.colltype
$function$
