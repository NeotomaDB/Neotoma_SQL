CREATE OR REPLACE FUNCTION ts.updateanalysisunitdepth(_analysisunitid integer, _depth float)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.analysisunits AS aus
	SET   depth = _depth
	WHERE aus.analysisunitid = analysisunitid
$function$;
