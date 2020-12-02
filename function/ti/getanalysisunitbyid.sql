CREATE OR REPLACE FUNCTION ti.getanalysisunitbyid(_analunitid integer)
RETURNS TABLE(collectionunitid integer,
              analysisunitname character varying,
              depth double precision,
              thickness double precision)
LANGUAGE sql
AS $function$
  SELECT au.collectionunitid,
         au.analysisunitname,
         au.depth,
         au.thickness
  FROM ndb.analysisunits AS au
  WHERE analysisunitid = _analunitid;
$function$
