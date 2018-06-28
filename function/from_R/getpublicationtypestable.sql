CREATE OR REPLACE FUNCTION ti.getpublicationtypestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       *
 FROM ndb.publicationtypes;
$function$