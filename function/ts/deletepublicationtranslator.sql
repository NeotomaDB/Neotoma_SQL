CREATE OR REPLACE FUNCTION ts.deletepublicationtranslator (_translatorid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.publicationtranslators AS pts
WHERE pts.translatorid = _translatorid;
$function$
