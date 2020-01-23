CREATE OR REPLACE FUNCTION ti.getvariableunitsid(_variableunits character varying)
 RETURNS TABLE(variableunitsid integer)
 LANGUAGE sql
AS $function$
SELECT vu.variableunitsid
FROM
  ndb.variableunits AS vu
WHERE vu.variableunits ILIKE $1

$function$
