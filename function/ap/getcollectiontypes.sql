CREATE OR REPLACE FUNCTION ap.getcollectiontypes()
 RETURNS TABLE(colltypeid integer, colltype character varying)
 LANGUAGE sql
AS $function$
SELECT colltypeid, colltype FROM ndb.collectiontypes
ORDER BY colltype
$function$
