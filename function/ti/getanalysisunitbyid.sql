CREATE OR REPLACE FUNCTION ti.getanalysisunitbyid(_analyunitid integer)
RETURNS TABLE(collectionunitid integer, analysisunitname character varying, depth numeric, thickness numeric)
LANGUAGE sql
AS $function$
SELECT collectionunitid, analysisunitname, depth::numeric, thickness::numeric
FROM ndb.analysisunits
WHERE analysisunitid = _analyunitid;
$function$
