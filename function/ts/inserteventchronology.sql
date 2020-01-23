CREATE OR REPLACE FUNCTION ts.inserteventchronology(_analysisunitid integer, _eventid integer, _chroncontrolid integer, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.eventchronology (analysisunitid, eventid, chroncontrolid, notes)
  VALUES (_analysisunitid, _eventid, _chroncontrolid, _notes)
  RETURNING eventchronologyid
$function$
