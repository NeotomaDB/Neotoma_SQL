CREATE OR REPLACE FUNCTION ti.getcollectiontypebyid(_colltypeid integer)
 RETURNS TABLE(colltypeid integer, colltype character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN QUERY SELECT colltypeid, colltype
	FROM ndb.collectiontypes
	WHERE colltypeid = _colltypeid;
END;
$function$
