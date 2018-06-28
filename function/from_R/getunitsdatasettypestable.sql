CREATE OR REPLACE FUNCTION ti.getunitsdatasettypestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       *
 FROM ndb.unitsdatasettypes;
$function$