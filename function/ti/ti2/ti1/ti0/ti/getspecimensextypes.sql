CREATE OR REPLACE FUNCTION ti.getspecimensextypes()
 RETURNS TABLE(sexid integer, sex character varying)
 LANGUAGE sql
AS $function$
SELECT      sexid, sex
 FROM ndb.specimensextypes;
$function$
