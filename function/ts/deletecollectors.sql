CREATE OR REPLACE FUNCTION ts.deletecollectors (_collunitid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.collectors AS cs
WHERE cs.collectionunitid = _collunitid
$function$
