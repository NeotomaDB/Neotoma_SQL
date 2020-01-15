CREATE OR REPLACE FUNCTION ti.getdatasetcountbycollunittype(_collunittypeid integer)
 RETURNS TABLE(datasettype character varying, count bigint)
 LANGUAGE sql
AS $function$
SELECT ndb.datasettypes.datasettype, COUNT(ndb.datasets.datasetid) AS count
FROM ndb.collectionunits INNER JOIN
                      ndb.datasets ON ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid INNER JOIN
                      ndb.datasettypes ON ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid
GROUP BY ndb.collectionunits.colltypeid, ndb.datasettypes.datasettype
HAVING (ndb.collectionunits.colltypeid = _collunittypeid)
ORDER BY count desc;
$function$
