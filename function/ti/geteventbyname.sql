CREATE OR REPLACE FUNCTION ti.geteventbyname(_eventname character varying)
 RETURNS TABLE(eventid integer, eventtypeid integer, eventname character varying, c14age double precision, c14ageolder double precision, c14ageyounger double precision, calage double precision, calageyounger double precision, calageolder double precision, notes text)
 LANGUAGE sql
AS $function$
SELECT eventid, eventtypeid, eventname, c14age, c14ageolder, c14ageyounger, calage, calageyounger, calageolder, notes
FROM ndb.events
WHERE eventname ILIKE $1
$function$;
