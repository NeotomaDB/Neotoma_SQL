CREATE OR REPLACE FUNCTION ti.getcollunithandlecount(_handle character varying)
 RETURNS bigint
 LANGUAGE plpgsql
AS $function$
BEGIN
	SELECT COUNT(handle) AS count
	FROM ndb.collectionunits
	WHERE handle ILIKE _handle;
END;
$function$
