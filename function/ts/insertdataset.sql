CREATE OR REPLACE FUNCTION ts.insertdataset(_collectionunitid integer, _datasettypeid integer, _datasetname character varying DEFAULT NULL::character varying, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
INSERT INTO ndb.datasets(collectionunitid, datasettypeid, datasetname, notes)
VALUES (_collectionunitid, _datasettypeid, _datasetname, _notes)
RETURNING datasetid
$function$
