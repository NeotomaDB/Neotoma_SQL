CREATE OR REPLACE FUNCTION ts.insertcollector(_collunitid integer, _contactid integer, _collectororder integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
INSERT INTO ndb.collectors(collectionunitid, contactid, collectororder)
VALUES (_collunitid, _contactid, _collectororder)
RETURNING collectorid
$function$;
