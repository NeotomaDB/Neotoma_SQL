CREATE OR REPLACE FUNCTION ti.geteventtypebyname(_eventtype character varying)
 RETURNS TABLE(eventtypeid integer, eventtype character varying)
 LANGUAGE sql
AS $function$
SELECT eventtypeid, eventtype
FROM ndb.eventtypes
WHERE (eventtype = _eventtype);
$function$
