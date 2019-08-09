CREATE OR REPLACE FUNCTION ti.getanalysisunitbyid(_analyunitid integer)
RETURNS TABLE(collectionunitid integer, analysisunitname character varying, depth numeric, thickness numeric)
AS $$
SELECT collectionunitid, analysisunitname, depth::numeric, thickness::numeric
FROM ndb.analysisunits
WHERE analysisunitid = _analyunitid;
$$ LANGUAGE SQL;




