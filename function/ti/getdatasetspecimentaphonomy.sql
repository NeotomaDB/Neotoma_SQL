CREATE OR REPLACE FUNCTION ti.getdatasetspecimentaphonomy(_datasetid integer)
 RETURNS TABLE(specimenid integer, taphonomicsystem character varying, taphonomictype character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.specimens.specimenid, ndb.taphonomicsystems.taphonomicsystem, ndb.taphonomictypes.taphonomictype
FROM   ndb.samples INNER JOIN
                      ndb.data ON ndb.samples.sampleid = ndb.data.sampleid INNER JOIN
                      ndb.specimens ON ndb.data.dataid = ndb.specimens.dataid INNER JOIN
                      ndb.specimentaphonomy ON ndb.specimens.specimenid = ndb.specimentaphonomy.specimenid INNER JOIN
                      ndb.taphonomictypes ON ndb.specimentaphonomy.taphonomictypeid = ndb.taphonomictypes.taphonomictypeid INNER JOIN
                      ndb.taphonomicsystems ON ndb.taphonomictypes.taphonomicsystemid = ndb.taphonomicsystems.taphonomicsystemid
WHERE  ndb.samples.datasetid = _datasetid
$function$
