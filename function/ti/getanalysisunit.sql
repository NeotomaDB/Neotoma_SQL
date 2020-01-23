CREATE OR REPLACE FUNCTION ti.getanalysisunit(_collectionuniid integer, _analunitname character varying DEFAULT NULL::character varying, _depth double precision DEFAULT NULL::double precision, _thickness double precision DEFAULT NULL::double precision)
 RETURNS TABLE(analysisunitid integer)
 LANGUAGE plpgsql
AS $function$
	BEGIN
	
	IF _analunitname IS NULL AND _depth IS NOT NULL AND _thickness IS NOT NULL  THEN
		  RETURN QUERY (SELECT analysisunits.analysisunitid
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname IS NULL) AND (depth = _depth) AND (thickness = _thickness)); 
	ELSIF _analunitname IS NULL AND _depth IS NOT NULL AND _thickness IS NULL THEN
		  RETURN QUERY (SELECT analysisunits.analysisunitid
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname IS NULL) AND (depth = _depth) AND (thickness IS NULL));
	ELSIF _analunitname IS NOT NULL AND _depth IS NOT NULL AND _thickness IS NULL THEN
		  RETURN QUERY (SELECT analysisunits.analysisunitid
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname = _analunitname) AND (depth = _depth) AND (thickness IS NULL));
	ELSIF _analunitname IS NOT NULL AND _depth IS NULL AND _thickness IS NULL THEN
		  RETURN QUERY (SELECT analysisunits.analysisunitid
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname = _analunitname) AND (depth IS NULL) AND (thickness IS NULL)); 
	ELSIF _analunitname IS NOT NULL AND _depth IS NULL AND _thickness IS NOT NULL THEN
		  RETURN QUERY (SELECT analysisunits.analysisunitid
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname = _analunitname) AND (depth IS NULL) AND (thickness = _thickness)); 
	ELSIF _analunitname IS NOT NULL AND _depth IS NOT NULL AND _thickness IS NOT NULL THEN
		  RETURN QUERY (SELECT analysisunits.analysisunitid
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname = _analunitname) AND (depth = _depth) AND (thickness = _thickness));
	ELSE
		--do nothing
	END IF;

	END;
$function$
