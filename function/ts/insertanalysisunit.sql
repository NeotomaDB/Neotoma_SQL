CREATE OR REPLACE FUNCTION ts.insertanalysisunit(_collectionunitid integer, _analysisunitname character varying DEFAULT NULL::character varying, _depth double precision DEFAULT NULL::double precision, _thickness double precision DEFAULT NULL::double precision, _faciesid integer DEFAULT NULL::integer, _mixed boolean DEFAULT NULL::boolean, _igsn character varying DEFAULT NULL::character varying, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
INSERT INTO ndb.analysisunits
	(collectionunitid, analysisunitname, depth, thickness, faciesid, mixed, igsn, notes)
VALUES (_collectionunitid, _analysisunitname, _depth, _thickness, _faciesid, _mixed, _igsn, _notes)
RETURNING analysisunitid
$function$
