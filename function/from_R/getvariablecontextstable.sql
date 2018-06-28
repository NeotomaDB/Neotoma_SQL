CREATE OR REPLACE FUNCTION ti.getvariablecontextstable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      variablecontextid, variablecontext
 FROM ndb.variablecontexts;
$function$