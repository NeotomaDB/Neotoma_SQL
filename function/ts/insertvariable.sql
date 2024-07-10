CREATE OR REPLACE FUNCTION ts.insertvariable(_taxonid integer, _variableelementid integer, _variableunitsid integer DEFAULT NULL::integer, _variablecontextid integer DEFAULT NULL::integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.variables (taxonid, variableelementid, variableunitsid,
    variablecontextid)
  VALUES (_taxonid, _variableelementid, _variableunitsid, _variablecontextid)
  ON CONFLICT (taxonid, variableelementid, variableunitsid, variablecontextid)
  DO NOTHING
  RETURNING variableid
$function$
