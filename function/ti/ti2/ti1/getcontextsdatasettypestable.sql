CREATE OR REPLACE FUNCTION ti.getcontextsdatasettypestable()
 RETURNS TABLE(datasettypeid integer, variablecontextid integer)
 LANGUAGE sql
AS $function$
SELECT ndb.contextsdatasettypes.datasettypeid, ndb.contextsdatasettypes.variablecontextid
FROM ndb.contextsdatasettypes
$function$
