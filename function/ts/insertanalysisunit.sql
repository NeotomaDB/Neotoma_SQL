CREATE OR REPLACE FUNCTION ts.insertanalysisunit(
	_collectionunitid integer,
	_analysisunitname character varying = null,
	_depth float = null,
	_thickness float = null,
	_faciesid integer = null,
	_mixed smallint = null,
	_igsn character varying = null,
	_notes character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
INSERT INTO ndb.analysisunits
	(collectionunitid, analysisunitname, depth, thickness, faciesid, mixed, igsn, notes)
VALUES (_collectionunitid, _analysisunitname, _depth, _thickness, _faciesid, _mixed, _igsn, _notes)
RETURNING analysisunitid
$function$;
