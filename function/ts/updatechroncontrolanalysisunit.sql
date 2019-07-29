CREATE OR REPLACE FUNCTION ts.updatechroncontrolanalysisunit(_chroncontrolid integer, _analunitid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.chroncontrols AS cc
	SET   analysisunitid = _analunitid
	WHERE cc.chroncontrolid = _chroncontrolid
$function$
