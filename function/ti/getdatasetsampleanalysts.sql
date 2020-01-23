CREATE OR REPLACE FUNCTION ti.getdatasetsampleanalysts(_datasetid integer)
 RETURNS TABLE(sampleid integer, contactid integer)
 LANGUAGE sql
AS $function$
SELECT ndb.sampleanalysts.sampleid, ndb.sampleanalysts.contactid
FROM ndb.samples INNER JOIN
     ndb.sampleanalysts ON ndb.samples.sampleid = ndb.sampleanalysts.sampleid
WHERE ndb.samples.datasetid = _datasetid;
$function$
