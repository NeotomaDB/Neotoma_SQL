CREATE OR REPLACE FUNCTION ti.getelementmaturitybyname(_maturity character varying)
 RETURNS TABLE(maturityid integer, maturity character varying)
 LANGUAGE sql
AS $function$
SELECT maturityid, maturity 
FROM ndb.elementmaturities
WHERE maturity = _maturity 
$function$
