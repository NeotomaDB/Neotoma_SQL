CREATE OR REPLACE FUNCTION ts.updateevent(_eventid integer, _eventtypeid integer, _eventname character varying, _c14age double precision DEFAULT NULL::double precision, _c14ageyounger double precision DEFAULT NULL::double precision, _c14ageolder double precision DEFAULT NULL::double precision, _calage double precision DEFAULT NULL::double precision, _calageyounger double precision DEFAULT NULL::double precision, _calageolder double precision DEFAULT NULL::double precision, _notes character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.events AS es
	SET    eventtypeid = _eventtypeid,
			eventname = _eventname,
			c14age = _c14age,
			c14ageyounger = _c14ageyounger,
			c14ageolder = _c14ageolder,
			calage = _calage,
			calageyounger = _calageyounger,
			calageolder = _calageolder,
			notes = _notes
	WHERE  es.eventid = _eventid
$function$
