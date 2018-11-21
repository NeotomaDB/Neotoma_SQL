CREATE OR REPLACE FUNCTION ts.insertrelativechronology(_analysisunitid integer,
													   _relativeageid integer,
													   _chroncontrolid integer,
													   _notes character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.relativechronology (analysisunitid, relativeageid, chroncontrolid, notes)
  VALUES (_analysisunitid, _relativeageid, _chroncontrolid, _notes)
  RETURNING relativechronid
$function$;
