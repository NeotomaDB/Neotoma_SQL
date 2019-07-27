CREATE OR REPLACE FUNCTION ts.deleterelativeagepublication(_relativeageid integer, _publicationid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.relativeagepublications AS rap
WHERE rap.relativeageid = _relativeageid AND rap.publicationid = _publicationid
$function$
