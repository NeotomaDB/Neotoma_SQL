CREATE OR REPLACE FUNCTION ti.getsynonymtypestable()
 RETURNS SETOF ndb.synonymtypes
 LANGUAGE sql
AS $function$
SELECT       *
 FROM ndb.synonymtypes;
$function$
