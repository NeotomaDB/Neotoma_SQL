CREATE OR REPLACE FUNCTION ts.updatechroncontroldepththickness(_chroncontrolid integer,_depth integer,_thickness integer,_analunitid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.chroncontrols AS cc
	SET   depth = _depth, thickness = _thickness
	WHERE cc.chroncontrolid = _chroncontrolid AND analysisunitid = _analunitid;
$function$;