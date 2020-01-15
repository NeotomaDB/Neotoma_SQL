CREATE OR REPLACE FUNCTION ti.getanalysisunitsbycollunitid(_collunitid integer)
 RETURNS TABLE(analysisunitid integer,
             analysisunitname character varying,
                        depth double precision,
                    thickness double precision)
LANGUAGE sql
AS $function$

SELECT au.analysisunitid,
       au.analysisunitname,
       au.depth,
       au.thickness
FROM   ndb.analysisunits AS au
WHERE  au.collectionunitid = $1;

$funciton$
