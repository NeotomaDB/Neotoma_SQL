CREATE OR REPLACE FUNCTION ti.getelementpartid(_partname character varying)
 RETURNS TABLE(symmetryid integer, portionid integer, maturityid integer)
 LANGUAGE plpgsql
AS $function$
DECLARE
	symmetryid int;
	portionid int;
	maturityid int;

BEGIN
	BEGIN
		RETURN QUERY SELECT ndb.elementsymmetries.symmetryid INTO symmetryid
		FROM ndb.elementsymmetries WHERE ndb.elementsymmetries.symmetry ILIKE _partname;
	END;
	BEGIN
    	RETURN QUERY SELECT ndb.elementportions.portionid INTO portionid
		FROM ndb.elementportions WHERE ndb.elementportions.portion ILIKE _partname;
	END;
	
	BEGIN
		RETURN QUERY SELECT ndb.elementmaturities.maturityid INTO maturityid
		FROM ndb.elementmaturities WHERE ndb.elementmaturities.maturity ILIKE _partname;
	END;
	RETURN;
END;
$function$
