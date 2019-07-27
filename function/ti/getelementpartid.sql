CREATE OR REPLACE FUNCTION ti.getelementpartid(_partname character varying, OUT symmetryid integer, OUT portionid integer, OUT maturityid integer)
 RETURNS record
 LANGUAGE plpgsql
AS $function$
DECLARE
	symmetryid int;
	portionid int;
	maturityid int;

BEGIN
	SELECT ndb.elementsymmetries.symmetryid INTO symmetryid
	FROM ndb.elementsymmetries WHERE ndb.elementsymmetries.symmetry = _partname;

	SELECT ndb.elementportions.portionid INTO portionid
	FROM ndb.elementportions WHERE ndb.elementportions.portion = _partname;
	
	SELECT ndb.elementmaturities.maturityid INTO maturityid
	FROM ndb.elementmaturities WHERE ndb.elementmaturities.maturity = _partname;

END;
$function$
