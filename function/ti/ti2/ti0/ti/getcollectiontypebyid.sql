CREATE OR REPLACE FUNCTION ti.getcollectiontypebyid(integer)
 RETURNS TABLE(colltypeid integer, colltype character varying)
 LANGUAGE sql
AS $function$
SELECT colltypeid, colltype
FROM ndb.collectiontypes
WHERE colltypeid = $1; 
$function$
