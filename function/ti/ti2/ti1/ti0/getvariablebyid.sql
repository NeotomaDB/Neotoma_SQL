CREATE OR REPLACE FUNCTION ti.getvariablebyid(_variableid integer)
 RETURNS TABLE(variableid integer, taxonid integer, variableelementid integer, variableunitsid integer, variablecontextid integer)
 LANGUAGE sql
AS $function$
SELECT 
   vr.variableid, 
   vr.taxonid, 
   vr.variableelementid, 
   vr.variableunitsid, 
   vr.variablecontextid
FROM
  ndb.variables AS vr
WHERE
  vr.variableid = _variableid
$function$
