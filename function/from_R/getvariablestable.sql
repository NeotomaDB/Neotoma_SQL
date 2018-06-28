CREATE OR REPLACE FUNCTION ti.getvariablestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       *
 FROM ndb.variables;
$function$