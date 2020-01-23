CREATE OR REPLACE FUNCTION ts.updateevent(_eventid integer,
										  _eventtypeid integer,
										  _eventname character varying,
										  _c14age float = null,
										  _c14ageyounger float = null,
										  _c14ageolder float = null,
										  _calage float = null,
										  _calageyounger float = null,
										  _calageolder float = null,
										  _notes character varying = null)
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
$function$;
