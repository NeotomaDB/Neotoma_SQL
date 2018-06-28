CREATE OR REPLACE FUNCTION ti.getpublicationstable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       *
 FROM ndb.publications;
$function$