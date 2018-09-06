CREATE OR REPLACE FUNCTION ti.getcontextdatasettypecount(_datasettypeid integer, _variablecontextid integer)
 RETURNS bigint
 LANGUAGE sql
AS $function$
SELECT COUNT(datasettypeid) AS count
FROM ndb.contextsdatasettypes
WHERE datasettypeid = _datasettypeid AND variablecontextid = _variablecontextid;
$function$
