CREATE OR REPLACE FUNCTION ti.getanalysisunit(_collectionunitid integer, _analunitname character varying DEFAULT NULL::character varying, _depth double precision DEFAULT NULL::double precision, _thickness double precision DEFAULT NULL::double precision)
 RETURNS TABLE(analysisunitid integer)
 LANGUAGE sql
AS $function$
	SELECT analysisunits.analysisunitid
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid)
      AND (_analysisunitname IS NULL) OR (analysisunitname = _analunitname)
      AND (_depth IS NULL) OR (depth = _depth)
      AND (_thickness IS NULL) OR (thickness = _thickness);
$function$
