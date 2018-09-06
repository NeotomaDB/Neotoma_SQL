CREATE OR REPLACE FUNCTION ti.getchronocontrolsbyanalysisunitid(analunitid integer)
 RETURNS TABLE(chroncontrolid integer)
 LANGUAGE sql
AS $function$

select    chroncontrolid
from      ndb.chroncontrols
where     (analysisunitid = $1)

$function$
