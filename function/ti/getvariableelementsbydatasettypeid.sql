CREATE OR REPLACE FUNCTION ti.getvariableelementsbydatasettypeid(_datasettypeid integer)
 RETURNS TABLE(variableelementid integer, variableelement character varying, elementtypeid integer, symmetryid integer, portionid integer, maturityid integer, taxagroupid character varying)
 LANGUAGE sql
AS $function$
SELECT
  ve.variableelementid,
  ve.variableelement,
  ve.elementtypeid,
  ve.symmetryid,
  ve.portionid,
  ve.maturityid,
  edtg.taxagroupid
FROM
                     ndb.variableelements AS ve
  INNER JOIN ndb.elementdatasettaxagroups AS edtg ON ve.elementtypeid = edtg.elementtypeid
WHERE     (edtg.datasettypeid = datasettypeid)
ORDER BY edtg.taxagroupid, ve.variableelement

$function$
