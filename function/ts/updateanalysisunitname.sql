CREATE OR REPLACE FUNCTION ts.updateanalysisunitname(_analysisunitid integer, _analysisunitname character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.analysisunits AS aus
	SET   analysisunitname = _analysisunitname
	WHERE aus.analysisunitid = _analysisunitid
$function$
