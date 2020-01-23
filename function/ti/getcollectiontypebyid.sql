CREATE OR REPLACE FUNCTION ti.getcollectiontypebyid(_colltypeid integer)
 RETURNS TABLE(colltypeid integer,
               colltype character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN QUERY SELECT cty.colltypeid, cty.colltype
	FROM ndb.collectiontypes AS cty
	WHERE cty.colltypeid = _colltypeid;
END;
$function$
