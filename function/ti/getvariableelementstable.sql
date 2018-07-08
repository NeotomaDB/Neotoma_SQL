CREATE OR REPLACE FUNCTION ti.getvariableelementstable()
 RETURNS TABLE(variableelementid integer, variableelement character varying, elementtypeid integer, symmetryid integer, portionid integer, maturityid integer)
 LANGUAGE sql
AS $function$
SELECT      variableelementid, variableelement, elementtypeid, symmetryid, portionid, maturityid
 FROM ndb.variableelements;
$function$
