CREATE OR REPLACE FUNCTION ti.getpublicationeditors(_publicationid integer)
 RETURNS TABLE(editorid integer, publicationid integer, editororder integer, familyname character varying, initials character varying, suffix character varying)
 LANGUAGE sql
AS $function$
SELECT editorid, publicationid, editororder, familyname, initials, suffix
FROM ndb.publicationeditors
WHERE (publicationid = _publicationid)
ORDER BY editororder;
$function$
