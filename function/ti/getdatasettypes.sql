CREATE OR REPLACE FUNCTION ti.getdatasettypes()
 RETURNS TABLE(datasettypeid integer, datasettype character varying)
 LANGUAGE sql
AS $function$
SELECT datasettypeid, datasettype
FROM ndb.datasettypes 
$function$
