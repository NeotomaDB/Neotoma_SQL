CREATE OR REPLACE FUNCTION ti.getcollunithandlecount(_handle character varying)
 RETURNS TABLE (count bigint)
 LANGUAGE sql
AS $function$
	SELECT COUNT(cu.handle) AS count
	FROM ndb.collectionunits AS cu
	WHERE cu.handle ILIKE _handle;
$function$
