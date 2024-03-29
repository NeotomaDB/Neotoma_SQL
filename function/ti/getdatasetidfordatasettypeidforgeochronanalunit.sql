CREATE OR REPLACE FUNCTION ti.getdatasetidfordatasettypeidforgeochronanalunit(_geochronid integer, _datasettypeid integer)
 RETURNS TABLE(datasetid integer)
 LANGUAGE sql
AS $function$

	SELECT ds.datasetid
	FROM   ndb.geochronology AS gc
	  INNER JOIN ndb.samples AS samp ON gc.sampleid = samp.sampleid
		INNER JOIN ndb.analysisunits AS au ON samp.analysisunitid = au.analysisunitid
		INNER JOIN ndb.datasets AS ds ON au.collectionunitid = ds.collectionunitid
	WHERE  (gc.geochronid = _geochronid) AND (ds.datasettypeid = _datasettypeid)

$function$
