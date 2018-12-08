CREATE OR REPLACE FUNCTION ts.insertvariableelement(
  _variableelement character varying,
  _elementtype integer,
  _symmetryid integer = null,
  _portionid integer = null,
  _maturityid integer = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.variableelements(variableelement, elementtypeid, symmetryid,
    portionid, maturityid)
  VALUES (_variableelement, _elementtype, _symmetryid, _portionid,
    _maturityid)
  RETURNING variableelementid
$function$;
