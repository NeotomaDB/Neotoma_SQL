CREATE OR REPLACE FUNCTION ts.inserteventpublication(_eventid integer, _publicationid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.eventpublications (eventid, publicationid)
  VALUES (_eventid, _publicationid)
$function$
