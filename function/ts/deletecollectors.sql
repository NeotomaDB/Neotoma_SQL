CREATE OR REPLACE FUNCTION ts.deletecollectors (_collunitid integer)
 LANGUAGE sql
AS $function$
delete from ndb.collectors AS cs
where cs.collectionunitid = _collunitid
$function$
