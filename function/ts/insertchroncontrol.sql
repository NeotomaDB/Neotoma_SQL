CREATE OR REPLACE FUNCTION ts.insertchroncontrol(_chronologyid integer, _chroncontroltypeid integer, _analysisunitid integer DEFAULT NULL::integer, _depth double precision DEFAULT NULL::double precision, _thickness double precision DEFAULT NULL::double precision, _agetypeid integer DEFAULT NULL::integer, _age double precision DEFAULT NULL::double precision, _agelimityounger double precision DEFAULT NULL::double precision, _agelimitolder double precision DEFAULT NULL::double precision, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
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
$function$
