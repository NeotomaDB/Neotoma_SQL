CREATE OR REPLACE FUNCTION ti.getvariableelementbyname(_variableelement character varying)
 RETURNS TABLE(variableelementid integer, elementtypeid integer, symmetryid integer, portionid integer, maturityid integer)
 LANGUAGE sql
AS $function$
SELECT
  ve.variableelementid,
  ve.elementtypeid,
  ve.symmetryid,
  ve.portionid,
  ve.maturityid
FROM ndb.variableelements as ve
WHERE
  ve.variableelement ILIKE variableelement
$function$
