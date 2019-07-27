CREATE OR REPLACE FUNCTION ti.getdatasetspecimengenbanknrs(_datasetid integer)
 RETURNS TABLE(specimenid integer, genbanknr character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.specimens.specimenid, ndb.specimengenbank.genbanknr
FROM   ndb.samples INNER JOIN
                      ndb.data ON ndb.samples.sampleid = ndb.data.sampleid INNER JOIN
                      ndb.specimens ON ndb.data.dataid = ndb.specimens.dataid INNER JOIN
                      ndb.specimengenbank ON ndb.specimens.specimenid = ndb.specimengenbank.specimenid
where  ndb.samples.datasetid = _datasetid
$function$
