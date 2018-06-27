CREATE OR REPLACE FUNCTION ap.getdatasettypes()
 RETURNS TABLE(datasettype character varying, datasettypeid integer)
 LANGUAGE sql
AS $function$
SELECT ndb.datasettypes.datasettype, ndb.datasets.datasettypeid
FROM ndb.datasets INNER JOIN
ndb.datasettypes ON ndb.datasettypes.datasettypeid = ndb.datasets.datasettypeid
GROUP BY ndb.datasettypes.datasettype, ndb.datasets.datasettypeid
ORDER BY ndb.datasettypes.datasettype
$function$
