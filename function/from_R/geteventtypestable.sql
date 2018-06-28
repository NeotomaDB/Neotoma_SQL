CREATE OR REPLACE FUNCTION ti.geteventtypestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       eventtypeid, eventtype, chroncontroltypeid
 FROM ndb.eventtypes;
$function$