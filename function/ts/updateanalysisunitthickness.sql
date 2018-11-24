CREATE OR REPLACE FUNCTION ts.updateanalysisunitthickness(_analysisunitid integer, _thickness float)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.analysisunits AS aus
	SET   thickness = _thickness
	WHERE aus.analysisunitid = analysisunitid
$function$;
