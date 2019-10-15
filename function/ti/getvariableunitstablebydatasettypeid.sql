CREATE OR REPLACE FUNCTION ti.getvariableunitstablebydatasettypeid(_datasettypeid integer)
 RETURNS TABLE(variableunits character varying)
 LANGUAGE sql
AS $function$
SELECT vu.variableunits
FROM
  ndb.unitsdatasettypes AS udt
  INNER JOIN ndb.variableunits AS vu ON udt.variableunitsid = vu.variableunitsid
WHERE udt.datasettypeid = $1

$function$
