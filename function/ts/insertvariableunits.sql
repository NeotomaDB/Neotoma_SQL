CREATE OR REPLACE FUNCTION ts.insertvariableunits(_units character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.variableunits(variableunits)
  VALUES (_units)
  RETURNING variableunitsid
$function$;
