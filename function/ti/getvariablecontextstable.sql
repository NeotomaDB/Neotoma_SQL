CREATE OR REPLACE FUNCTION ti.getvariablecontextstable()
 RETURNS TABLE(variablecontextid integer, variablecontext character varying)
 LANGUAGE sql
AS $function$
SELECT      variablecontextid, variablecontext
 FROM ndb.variablecontexts;
$function$
