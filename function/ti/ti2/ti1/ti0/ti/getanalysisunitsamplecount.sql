CREATE OR REPLACE FUNCTION ti.getanalysisunitsamplecount(_analunitid integer)
 RETURNS TABLE(count bigint)
 LANGUAGE sql
AS $function$
SELECT     count(analysisunitid) AS count
FROM       ndb.samples
WHERE      analysisunitid = _analunitid;
$function$
