CREATE OR REPLACE FUNCTION ti.getdatasetsampleids(_datasetid integer)
 RETURNS TABLE(sampleid integer)
 LANGUAGE sql
AS $function$
SELECT sampleid
FROM ndb.samples
WHERE (datasetid = _datasetid)
ORDER BY sampleid;
$function$
