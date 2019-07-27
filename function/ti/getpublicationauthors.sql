CREATE OR REPLACE FUNCTION ti.getpublicationauthors(_publicationid integer)
 RETURNS TABLE(authorid integer, publicationid integer, authororder integer, familyname character varying, initials character varying, suffix character varying, contactid integer)
 LANGUAGE sql
AS $function$
SELECT authorid, publicationid, authororder, familyname, initials, suffix, contactid
FROM ndb.publicationauthors
WHERE (publicationid = _publicationid)
ORDER BY authororder;
$function$
