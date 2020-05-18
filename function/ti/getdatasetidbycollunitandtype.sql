CREATE OR REPLACE FUNCTION ti.getdatasetidbycollunitandtype(_collunitid integer, _datasettypeid integer)
 RETURNS TABLE(datasetid integer)
 LANGUAGE sql
AS $function$
	SELECT ds.datasetid
	FROM ndb.datasets AS ds
	WHERE ds.datasettypeid = _datasettypeid AND ds.collectionunitid = _collunitid;
$function$
