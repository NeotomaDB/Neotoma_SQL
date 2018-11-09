CREATE OR REPLACE FUNCTION ts.insertevent(_eventtypeid integer,
										  _eventname character varying,
										  _c14age float = null,
										  _c14ageyounger float = null,
										  _c14ageolder float = null,
										  _calage float = null,
										  _calageyounger float = null,
										  _calageolder float = null,
										  _notes character varying = null)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.events (eventtypeid, eventname, c14age, c14ageyounger, c14ageolder, calage, calageyounger, calageolder, notes)
  VALUES (_eventtypeid, _eventname, _c14age, _c14ageyounger, _c14ageolder, _calage, _calageyounger, _calageolder, _notes)
  RETURNING eventid
$function$;
