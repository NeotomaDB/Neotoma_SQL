CREATE OR REPLACE FUNCTION ts.insertrelativeagepublication(_relativeageid integer,
  _publicationid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.relativeagepublications(relativeageid, publicationid)
  VALUES (_relativeageid, _publicationid)
$function$;
