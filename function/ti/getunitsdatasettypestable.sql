CREATE OR REPLACE FUNCTION ti.getunitsdatasettypestable()
 RETURNS SETOF ndb.unitsdatasettypes
 LANGUAGE sql
AS $function$
SELECT       *
 FROM ndb.unitsdatasettypes;
$function$
