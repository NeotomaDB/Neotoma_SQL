CREATE OR REPLACE FUNCTION ts.deleteeventpublication (_eventid integer, _publicationid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.eventpublications AS ep
WHERE ep.eventid = _eventid AND ep.publicationid = _publicationid;
$function$
