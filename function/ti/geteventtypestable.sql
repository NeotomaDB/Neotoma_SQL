CREATE OR REPLACE FUNCTION ti.geteventtypestable()
 RETURNS TABLE(eventtypeid integer, eventtype character varying, chroncontroltypeid integer)
 LANGUAGE sql
AS $function$
SELECT eventtypeid, eventtype, chroncontroltypeid
FROM ndb.eventtypes;
$function$
