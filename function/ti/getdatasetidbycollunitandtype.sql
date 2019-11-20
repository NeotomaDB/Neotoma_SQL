CREATE OR REPLACE FUNCTION ti.getdatasetidbycollunitandtype(_collunitid integer, _datasettypeid integer)
 RETURNS TABLE(datasetid integer)
 LANGUAGE sql
AS $function$
	SELECT ds.datasetid
	FROM ndb.datasets AS ds
	WHERE ds.datasettypeid = $2 AND ds.collectionunitid = $1;
$function$
