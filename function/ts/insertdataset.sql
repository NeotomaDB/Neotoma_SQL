CREATE OR REPLACE FUNCTION ts.insertdataset(
	_collectionunitid integer,
	_datasettypeid integer,
	_datasetname character varying = null,
	_notes character varying = null)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.datasets(collectionunitid, datasettypeid, datasetname, notes)
VALUES (_collectionunitid, _datasettypeid, _datasetname, _notes)
$function$;

---return id
SELECT scope_identity();
