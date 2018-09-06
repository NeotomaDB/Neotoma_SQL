CREATE OR REPLACE FUNCTION ti.getvariablecontextid(_variablecontext character varying)
 RETURNS TABLE(variablecontextid integer)
 LANGUAGE sql
AS $function$
SELECT 
  vc.variablecontextid
FROM
  ndb.variablecontexts AS vc
WHERE
  vc.variablecontext LIKE _variablecontext
$function$
