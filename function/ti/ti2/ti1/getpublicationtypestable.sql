CREATE OR REPLACE FUNCTION ti.getpublicationtypestable()
 RETURNS SETOF ndb.publicationtypes
 LANGUAGE sql
AS $function$
SELECT       *
 FROM ndb.publicationtypes;
$function$
