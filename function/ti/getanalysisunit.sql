CREATE OR REPLACE FUNCTION ti.getanalysisunit(_collectionuniid integer, _analunitname character varying DEFAULT NULL::character varying, _depth double precision DEFAULT NULL::double precision, _thickness double precision DEFAULT NULL::double precision)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
	DECLARE _analysisunit integer;
	BEGIN
	
	IF  _analunitname IS NULL AND _depth IS NOT NULL AND _thickness IS NOT NULL  THEN
	  SELECT analysisunitid
	  INTO _analysisunit
	  FROM   ndb.analysisunits
	  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname IS NULL) AND (depth = _depth) AND (thickness = _thickness); 
	ELSEIF _analunitname IS NULL AND _depth IS NOT NULL AND _thickness IS NULL THEN
		  SELECT analysisunitid
		  INTO _analysisunit
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname IS NULL) AND (depth = _depth) AND (thickness IS NULL);
	ELSEIF _analunitname IS NOT NULL AND _depth IS NOT NULL AND _thickness IS NULL THEN
		  SELECT analysisunitid
		  INTO _analysisunit
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname = _analunitname) AND (depth = _depth) AND (thickness IS NULL);
	ELSEIF _analunitname IS NOT NULL AND _depth IS NULL AND _thickness IS NULL THEN
		  SELECT analysisunitid
		  INTO _analysisunit
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname = _analunitname) AND (depth IS NULL) AND (thickness IS NULL); 
	ELSEIF _analunitname IS NOT NULL AND _depth IS NULL AND _thickness IS NOT NULL THEN
		  SELECT analysisunitid
		  INTO _analysisunit
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname = _analunitname) AND (depth IS NULL) AND (thickness = _thickness); 
	ELSEIF _analunitname IS NOT NULL AND _depth IS NOT NULL AND _thickness IS NOT NULL THEN
		  SELECT analysisunitid
		  INTO _analysisunit
		  FROM   ndb.analysisunits
		  WHERE  (collectionunitid = _collectionuniid) AND (analysisunitname = _analunitname) AND (depth = _depth) AND (thickness = _thickness);
	ELSE
		--do nothing
	END IF;

	RETURN _analysisunit;
	END;
$function$
