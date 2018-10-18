CREATE OR REPLACE FUNCTION ts.insertanalysisunitaltdepthscale(
	_altdepthid integer,
	_altdepthname character varying,
	_variableunitsid integer,
	_notes character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.analysisunitaltdepthscales(altdepthid, altdepthname, variableunitsid, notes)
  VALUES (_altdepthid, _altdepthname, _variableunitsid, _notes)
  RETURNING altdepthscaleid
$function$;
