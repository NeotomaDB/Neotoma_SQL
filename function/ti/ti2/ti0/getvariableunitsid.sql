CREATE OR REPLACE FUNCTION ti.getvariableunitsid(variableunits character varying)
 RETURNS TABLE(variableunitsid integer)
 LANGUAGE sql
AS $function$
SELECT vu.variableunitsid
FROM
  ndb.variableunits AS vu
WHERE vu.variableunits = variableunits

$function$
