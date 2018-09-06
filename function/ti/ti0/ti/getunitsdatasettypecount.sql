CREATE OR REPLACE FUNCTION ti.getunitsdatasettypecount(_datasettypeid integer, _variableunitsid integer)
 RETURNS TABLE(count bigint)
 LANGUAGE sql
AS $function$
  SELECT
    COUNT(datasettypeid) AS count
  FROM ndb.unitsdatasettypes AS dst
  WHERE (dst.datasettypeid = _datasettypeid) and (dst.variableunitsid = _variableunitsid)
$function$
