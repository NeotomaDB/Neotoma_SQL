CREATE OR REPLACE FUNCTION ts.insertvariablecontext(_context character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.variablecontexts(variablecontext)
  VALUES (_context)
  RETURNING variablecontextid
$function$
