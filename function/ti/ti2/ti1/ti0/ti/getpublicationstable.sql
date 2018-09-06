CREATE OR REPLACE FUNCTION ti.getpublicationstable()
 RETURNS SETOF ndb.publications
 LANGUAGE sql
AS $function$
SELECT       *
 FROM ndb.publications;
$function$
