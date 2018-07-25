CREATE OR REPLACE FUNCTION ti.getvariableelementbypartids(_symmetryid integer, _portionid integer)
 RETURNS TABLE(variableelementid integer)
 LANGUAGE sql
AS $function$
SELECT 
  ve.variableelementid 
FROM ndb.variableelements as ve
WHERE
  ve.symmetryid = _symmetryid AND
  ve.portionid  = _portionid 
$function$
