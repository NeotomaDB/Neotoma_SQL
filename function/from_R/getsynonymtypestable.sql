CREATE OR REPLACE FUNCTION ti.getsynonymtypestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       *
 FROM ndb.[synonymtypes];
$function$