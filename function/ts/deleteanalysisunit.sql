<<<<<<< HEAD
CREATE OR REPLACE FUNCTION ts.deleteanalysisunit(_analunitid integer)
=======
DROP FUNCTION ts.deleteanalysisunit (integer);

CREATE OR REPLACE FUNCTION ts.deleteanalysisunit (_analunitid integer)
>>>>>>> Anna_SQL
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.analysisunits AS au
WHERE au.analysisunitid = _analunitid;
$function$
