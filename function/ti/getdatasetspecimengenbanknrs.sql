CREATE OR REPLACE FUNCTION ti.getdatasetspecimengenbanknrs(_datasetid integer)
 RETURNS TABLE(specimenid integer, genbanknr character varying)
 LANGUAGE sql
AS $function$
SELECT spe.specimenid, sgb.genbanknr
FROM   ndb.samples AS sam INNER JOIN
                      ndb.data AS dt ON sam.sampleid = dt.sampleid INNER JOIN
                      ndb.specimens AS spe ON dt.dataid = spe.dataid INNER JOIN
                      ndb.specimengenbank AS sgb ON spe.specimenid = sgb.specimenid
where  sam.datasetid = _datasetid
$function$
