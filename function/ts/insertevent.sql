CREATE OR REPLACE FUNCTION ts.insertevent(_eventtypeid integer, _eventname character varying, _c14age double precision DEFAULT NULL::double precision, _c14ageyounger double precision DEFAULT NULL::double precision, _c14ageolder double precision DEFAULT NULL::double precision, _calage double precision DEFAULT NULL::double precision, _calageyounger double precision DEFAULT NULL::double precision, _calageolder double precision DEFAULT NULL::double precision, _notes character varying DEFAULT NULL::character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.events (eventtypeid, eventname, c14age, c14ageyounger, c14ageolder, calage, calageyounger, calageolder, notes)
  VALUES (_eventtypeid, _eventname, _c14age, _c14ageyounger, _c14ageolder, _calage, _calageyounger, _calageolder, _notes)
  RETURNING eventid
$function$
