CREATE OR REPLACE FUNCTION ts.insertvariable(
  _taxonid integer,
  _variableelementid integer,
  _variableunitsid integer = null,
  _variablecontextid integer = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.variables (taxonid, variableelementid, variableunitsid,
    variablecontextid)
  VALUES (_taxonid, _variableelementid, _variableunitsid, _variablecontextid)
  RETURNING variableid
$function$;
