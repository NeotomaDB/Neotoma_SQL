<<<<<<< HEAD
CREATE OR REPLACE FUNCTION ts.deleterelativeagepublication(_relativeageid integer, _publicationid integer)
=======
CREATE OR REPLACE FUNCTION ts.deleterelativeagepublication (_relativeageid integer, _publicationid integer)
>>>>>>> Anna_SQL
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.relativeagepublications AS rap
WHERE rap.relativeageid = _relativeageid AND rap.publicationid = _publicationid
$function$
