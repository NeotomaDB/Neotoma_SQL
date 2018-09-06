CREATE OR REPLACE FUNCTION ti.getdatasettypeshavingdata()
 RETURNS TABLE(datasettypeid integer, datasettype character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.datasettypes.datasettypeid, ndb.datasettypes.datasettype
FROM ndb.datasettypes INNER JOIN
	ndb.datasets ON ndb.datasettypes.datasettypeid = ndb.datasets.datasettypeid
GROUP BY ndb.datasettypes.datasettypeid, ndb.datasettypes.datasettype
$function$
