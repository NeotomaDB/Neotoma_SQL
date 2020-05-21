CREATE OR REPLACE FUNCTION ti.getanalysisunitsamplecount(_analunitid integer)
 RETURNS TABLE(count integer)
 LANGUAGE sql
AS $function$
SELECT     count(analysisunitid)::integer AS count
FROM       ndb.samples
WHERE      analysisunitid = $1;
$function$
