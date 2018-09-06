CREATE OR REPLACE FUNCTION ti.getvariablestable()
 RETURNS SETOF ndb.variables
 LANGUAGE sql
AS $function$
SELECT       *
 FROM ndb.variables;
$function$
