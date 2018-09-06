CREATE OR REPLACE FUNCTION ti.getanalysisunitsbycollunitid(collunitid integer)
 RETURNS TABLE(analysisunitid integer, analysisunitname character varying, depth double precision, thickness double precision)
 LANGUAGE sql
AS $function$

select     analysisunitid, analysisunitname, depth, thickness
from       ndb.analysisunits
where      (collectionunitid = $1)

$function$
