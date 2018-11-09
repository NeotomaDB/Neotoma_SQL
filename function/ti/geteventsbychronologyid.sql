CREATE OR REPLACE FUNCTION ti.geteventsbychronologyid(_chronologyid integer)
 RETURNS TABLE(chroncontrolid integer, eventname character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.eventchronology.chroncontrolid, ndb.events.eventname
FROM ndb.chroncontrols INNER JOIN
                      ndb.chronologies ON ndb.chroncontrols.chronologyid = ndb.chronologies.chronologyid INNER JOIN
                      ndb.eventchronology ON ndb.chroncontrols.chroncontrolid = ndb.eventchronology.chroncontrolid INNER JOIN
                      ndb.events ON ndb.eventchronology.eventid = ndb.events.eventid
WHERE ndb.chronologies.chronologyid = _chronologyid AND ndb.eventchronology.chroncontrolid IS NOT null;
$function$
