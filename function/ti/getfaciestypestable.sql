CREATE OR REPLACE FUNCTION ti.getfaciestypestable()
 RETURNS TABLE(faciesid integer, facies character varying)
 LANGUAGE sql
AS $function$
SELECT faciesid, facies
FROM ndb.faciestypes;
$function$
