CREATE OR REPLACE FUNCTION ti.geteventchroncontroltypeid(_eventname character varying)
 RETURNS TABLE(eventid integer, chroncontroltypeid integer)
 LANGUAGE sql
AS $function$
SELECT ndb.events.eventid, ndb.eventtypes.chroncontroltypeid
FROM ndb.eventtypes INNER JOIN
       ndb.events on ndb.eventtypes.eventtypeid = ndb.events.eventtypeid
WHERE ndb.events.eventname ILIKE $1
$function$
