CREATE OR REPLACE FUNCTION ti.getvariableunitstable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       *
 FROM ndb.variableunits;
$function$