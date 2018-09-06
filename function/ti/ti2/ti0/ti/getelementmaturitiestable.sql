CREATE OR REPLACE FUNCTION ti.getelementmaturitiestable()
 RETURNS TABLE(maturityid integer, maturity character varying)
 LANGUAGE sql
AS $function$
SELECT maturityid, maturity
FROM ndb.elementmaturities
$function$
