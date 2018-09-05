CREATE OR REPLACE FUNCTION ts.deletedataset(_datasetid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.samples AS ss
WHERE ss.datasetid = _datasetid;
DELETE FROM ndb.datasets AS ds
WHERE ds.datasetid = _datasetid;
$function$
