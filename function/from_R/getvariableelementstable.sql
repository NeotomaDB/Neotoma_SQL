CREATE OR REPLACE FUNCTION ti.getvariableelementstable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      variableelementid, variableelement, elementtypeid, symmetryid, portionid, maturityid
 FROM ndb.variableelements;
$function$