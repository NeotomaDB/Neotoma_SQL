CREATE OR REPLACE FUNCTION ti.getanalysisunitsamplecount(_analunitid integer)
 RETURNS TABLE(count INTEGER)
AS $$
SELECT     count(analysisunitid)::integer AS count
FROM       ndb.samples
WHERE      analysisunitid = $1;
$$ LANGUAGE SQL;
