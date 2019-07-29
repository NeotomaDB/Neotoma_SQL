CREATE OR REPLACE FUNCTION ti.getdatasetidbycollunitandtype(_collunitid integer, _datasettypeid integer)
 RETURNS TABLE(datasetid integer)
 LANGUAGE plpgsql
AS $function$
BEGIN

	SELECT datasetid
	FROM ndb.datasets
	WHERE datasettypeid = $2 AND collectionunitid = $1;

END;
$function$
