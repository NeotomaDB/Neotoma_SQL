CREATE OR REPLACE FUNCTION ts.inserttephra(_eventid integer, _analysisunitid integer, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.tephras(eventid, analysisunitid, notes)
  VALUES (_eventid, _analysisunitid, _notes)
  RETURNING tephraid
$function$
