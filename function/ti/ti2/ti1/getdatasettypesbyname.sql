CREATE OR REPLACE FUNCTION ti.getdatasettypesbyname(_datasettype character varying)
 RETURNS TABLE(datasettypeid integer, datasettype character varying)
 LANGUAGE plpgsql
AS $function$
DECLARE
	dt varchar(80) = _datasettype + '%';
BEGIN
	RETURN QUERY SELECT datasettypeid, datasettype
		FROM ndb.datasettypes
		WHERE datasettype LIKE dt;
END;
$function$
