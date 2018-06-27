CREATE OR REPLACE FUNCTION da.datasetbyid(dataid integer)
 RETURNS SETOF record
 LANGUAGE sql
AS $function$
SELECT ndb.datasets.datasetid, ndb.datasettypes.datasettype
FROM ndb.chronologies INNER JOIN ndb.collectionunits ON ndb.chronologies.collectionunitid = ndb.collectionunits.collectionunitid INNER JOIN
ndb.datasets ON ndb.collectionunits.collectionunitid = ndb.datasets.collectionunitid INNER JOIN
ndb.datasettypes ON ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid INNER JOIN
ndb.sampleages ON ndb.chronologies.chronologyid = ndb.sampleages.chronologyid INNER JOIN
ndb.samples ON ndb.sampleages.sampleid = ndb.samples.sampleid AND ndb.datasets.datasetid = ndb.samples.datasetid
WHERE ndb.sampleages.chronologyid = dataid
GROUP BY ndb.datasets.datasetid, ndb.datasettypes.datasettype;
$function$
