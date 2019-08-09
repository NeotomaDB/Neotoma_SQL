CREATE OR REPLACE FUNCTION ti.getanalysisunitsbycollunitid(_collunitid integer)
 RETURNS TABLE(analysisunitid integer, analysisunitname character varying, depth double precision, thickness double precision)
AS $$

select     analysisunitid, analysisunitname, depth, thickness
from       ndb.analysisunits
where      (collectionunitid = $1);

$$ LANGUAGE SQL;
