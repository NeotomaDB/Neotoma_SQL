CREATE OR REPLACE FUNCTION ts.insertchroncontrol(
	_chronologyid integer,
	_chroncontroltypeid integer,
	_analysisunitid integer = null,
	_depth float = null,
	_thickness float = null,
	_agetypeid integer = null,
	_age float = null,
	_agelimityounger float = null,
	_agelimitolder float = null,
	_notes character varying = null)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.chroncontrols(
	chronologyid,
	chroncontroltypeid,
	analysisunitid,
	depth,
	thickness,
	agetypeid,
	age,
	agelimityounger,
	agelimitolder,
	notes)
VALUES (_chronologyid, _chroncontroltypeid, _analysisunitid, _depth, _thickness, _agetypeid, _age, _agelimityounger, _agelimitolder, _notes)
RETURNING chroncontrolid
$function$;
