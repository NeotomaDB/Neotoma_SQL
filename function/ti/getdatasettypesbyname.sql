CREATE OR REPLACE FUNCTION ti.getdatasettypesbyname(_datasettype character varying)
 RETURNS TABLE(datasettypeid integer, datasettype character varying)
 LANGUAGE plpgsql
AS $function$
DECLARE
	dt text := $1::text || '%'::text;
BEGIN
	RETURN QUERY SELECT d."datasettypeid", d."datasettype"
	FROM ndb.datasettypes d
	WHERE d.datasettype ILIKE dt;
END;
$function$
