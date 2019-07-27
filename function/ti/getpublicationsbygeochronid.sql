CREATE OR REPLACE FUNCTION ti.getpublicationsbygeochronid(_geochronidlist character varying)
 RETURNS TABLE(geochronid integer, publicationid integer)
 LANGUAGE sql
AS $function$
SELECT geochronid, publicationid
FROM ndb.geochronpublications
WHERE geochronid in (SELECT unnest(string_to_array(_geochronidlist,'$'))::int);

$function$
