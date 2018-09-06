CREATE OR REPLACE FUNCTION ti.getvariablecontextstablebydatasettypeid(_datasettypeid integer)
 RETURNS TABLE(variablecontext character varying)
 LANGUAGE sql
AS $function$
SELECT 
  vc.variablecontext
FROM
  ndb.contextsdatasettypes as cd
  INNER JOIN ndb.variablecontexts AS vc ON cd.variablecontextid = vc.variablecontextid
WHERE
  cd.datasettypeid = _datasettypeid
$function$
