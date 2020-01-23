CREATE OR REPLACE FUNCTION ts.insertvariableelement(_variableelement character varying, _elementtype integer, _symmetryid integer DEFAULT NULL::integer, _portionid integer DEFAULT NULL::integer, _maturityid integer DEFAULT NULL::integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.variableelements(variableelement, elementtypeid, symmetryid,
    portionid, maturityid)
  VALUES (_variableelement, _elementtype, _symmetryid, _portionid,
    _maturityid)
  RETURNING variableelementid
$function$
