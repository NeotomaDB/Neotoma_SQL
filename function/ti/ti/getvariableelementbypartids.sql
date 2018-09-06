CREATE OR REPLACE FUNCTION ti.getvariableelementbypartids(_elementtypeid integer, _symmetryid integer, _portionid integer, _maturityid integer)
 RETURNS TABLE(variableelementid integer)
 LANGUAGE sql
AS $function$
SELECT 
  ve.variableelementid
FROM ndb.variableelements as ve
WHERE
  (COALESCE(ve.symmetryid, -1) = _symmetryid OR ve.symmetryid = _symmetryid) AND
  (COALESCE(ve.portionid, -1) = _portionid OR ve.portionid  = _portionid) AND
  (COALESCE(ve.maturityid, -1) = _maturityid OR ve.maturityid = _maturityid) AND
  (COALESCE(ve.elementtypeid, -1) = _elementtypeid OR ve.elementtypeid = _elementtypeid)
$function$
