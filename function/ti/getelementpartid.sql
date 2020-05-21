CREATE OR REPLACE FUNCTION ti.getelementpartid(_partname character varying)
 RETURNS TABLE(symmetryid integer, portionid integer, maturityid integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
	RETURN QUERY SELECT (SELECT ndb.elementsymmetries.symmetryid FROM ndb.elementsymmetries WHERE ndb.elementsymmetries.symmetry ILIKE $1) AS symmetryid,
	(SELECT ndb.elementportions.portionid FROM ndb.elementportions WHERE ndb.elementportions.portion ILIKE $1) AS portionid,
	(SELECT ndb.elementmaturities.maturityid FROM ndb.elementmaturities WHERE ndb.elementmaturities.maturity ILIKE $1) AS maturityid;
END;
$function$
