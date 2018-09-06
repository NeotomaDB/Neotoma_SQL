CREATE OR REPLACE FUNCTION ti.getvariableunitstable()
 RETURNS SETOF ndb.variableunits
 LANGUAGE sql
AS $function$
SELECT       *
 FROM ndb.variableunits;
$function$
