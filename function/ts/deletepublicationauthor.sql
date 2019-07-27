CREATE OR REPLACE FUNCTION ts.deletepublicationauthor(_authorid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.publicationauthors AS pa
WHERE pa.authorid = _authorid;
$function$
