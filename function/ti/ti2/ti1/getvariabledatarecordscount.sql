CREATE OR REPLACE FUNCTION ti.getvariabledatarecordscount(_variableid integer)
 RETURNS TABLE(count bigint)
 LANGUAGE sql
AS $function$
SELECT 
  COUNT(dt.variableid)
FROM 
  ndb.variables as vs
  INNER JOIN ndb.data AS dt ON vs.variableid = dt.variableid
WHERE
  vs.variableid = _variableid
$function$
