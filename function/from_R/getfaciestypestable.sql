CREATE OR REPLACE FUNCTION ti.getfaciestypestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       faciesid, facies
 FROM ndb.faciestypes;
$function$