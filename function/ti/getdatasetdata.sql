CREATE OR REPLACE FUNCTION ti.getdatasetdata(_datasetid integer)
 RETURNS TABLE(dataid integer, sampleid integer, variableid integer, value double precision, taphonomictypeid integer)
 LANGUAGE sql
AS $function$
SELECT ndb.data.dataid, ndb.data.sampleid, ndb.data.variableid, ndb.data.value, ndb.summarydatataphonomy.taphonomictypeid
FROM ndb.samples INNER JOIN
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid LEFT OUTER JOIN
                      ndb.summarydatataphonomy ON ndb.data.dataid = ndb.summarydatataphonomy.dataid
WHERE (ndb.samples.datasetid = _datasetid)
$function$
