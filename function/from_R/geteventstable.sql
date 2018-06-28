CREATE OR REPLACE FUNCTION ti.geteventstable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      eventid, eventtypeid, eventname, c14age, c14ageolder, c14ageyounger, calage, calageyounger, calageolder, notes
 FROM ndb.events;
$function$