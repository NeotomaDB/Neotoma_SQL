CREATE OR REPLACE FUNCTION ti.getanalysisunitbyid(_analyunitid integer)
RETURNS TABLE(collectionunitid integer, analysisunitname character varying, depth numeric, thickness numeric)
LANGUAGE sql
AS $function$
  SELECT au.collectionunitid,
         au.analysisunitname,
         au.depth::numeric,
         au.thickness::numeric
  FROM ndb.analysisunits AS au
  WHERE analysisunitid = _analyunitid;
$function$
