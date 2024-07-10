CREATE OR REPLACE FUNCTION ts.updatedatasettype(_datasetid INT, _datasettype character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.datasets
	SET   datasettypeid = (SELECT datasettypeid FROM ndb.datasettypes WHERE datasettype = _datasettype)
	WHERE datasetid = _datasetid
$function$;