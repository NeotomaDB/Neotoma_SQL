CREATE OR REPLACE FUNCTION ti.getpublicationtranslators(_publicationid integer)
 RETURNS TABLE(translatorid integer, publicationid integer, translatororder integer, familyname character varying, initials character varying, suffix character varying, recdatecreated timestamp without time zone, recdatemodified timestamp without time zone)
 LANGUAGE sql
AS $function$
SELECT ndb.publicationtranslators.*
FROM ndb.publicationtranslators
WHERE (publicationid = _publicationid)
ORDER BY translatororder;
$function$
