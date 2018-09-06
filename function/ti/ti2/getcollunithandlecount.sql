CREATE OR REPLACE FUNCTION ti.getcollunithandlecount(hand character varying)
 RETURNS bigint
 LANGUAGE sql
AS $function$
SELECT COUNT(handle) AS count
FROM ndb.collectionunits
WHERE handle = hand;
$function$
