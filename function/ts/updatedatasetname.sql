CREATE OR REPLACE FUNCTION ts.updatedatasetname(_datasetid integer, _datasetname character varying)
	RETURNS void
	LANGUAGE sql
AS $function$
	UPDATE ndb.datasets AS dss
	SET    datasetname = _datasetname
	WHERE  dss.datasetid = _datasetid
$function$;
