CREATE OR REPLACE FUNCTION ti.getcollectiontypestable()
 RETURNS TABLE(colltypeid integer, colltype character varying)
 LANGUAGE sql
AS $function$
SELECT colltypeid, colltype
FROM ndb.collectiontypes; 
$function$
