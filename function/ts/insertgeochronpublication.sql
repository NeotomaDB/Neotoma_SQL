CREATE OR REPLACE FUNCTION ts.insertgeochronpublication(_geochronid integer, _publicationid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.geochronpublications (geochronid, publicationid)
  VALUES (_geochronid, _publicationid)
$function$
