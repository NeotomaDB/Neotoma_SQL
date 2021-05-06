CREATE OR REPLACE FUNCTION ts.updatechroncontrolevent(_chroncontrolid integer, _eventid integer, _analysisunitid integer DEFAULT NULL::integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.eventchronology
    (analysisunitid, eventid, chroncontrolid)
  VALUES (_analysisunitid, _eventid, _chroncontrolid)
  ON CONFLICT ON CONSTRAINT uniqueeventset
  DO UPDATE
    SET   analysisunitid = _analysisunitid, eventid = _eventid, chroncontrolid = _chroncontrolid, notes = null
  WHERE ndb.eventchronology.eventchronologyid = (SELECT ec.eventchronologyid FROM ndb.eventchronology AS ec WHERE (chroncontrolid = _chroncontrolid))
$function$
