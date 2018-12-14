CREATE OR REPLACE FUNCTION ts.updatesampleanalysisunit(_sampleid integer, _analunitid integer)
	RETURNS void
	LANGUAGE sql
AS $function$
	UPDATE ndb.samples AS ss
	SET    analysisunitid = _analunitid
	WHERE  ss.sampleid = _sampleid
$function$;
