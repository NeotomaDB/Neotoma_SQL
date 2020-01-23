CREATE OR REPLACE FUNCTION ts.deletegeochronpublication(_geochronid integer, _publicationid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.geochronpublications AS gcp
WHERE gcp.geochronid = _geochronid AND gcp.publicationid = _publicationid;
$function$
