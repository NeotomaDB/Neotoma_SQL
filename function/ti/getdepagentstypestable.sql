CREATE OR REPLACE FUNCTION ti.getdepagentstypestable()
 RETURNS TABLE(depagentid integer, depagent character varying)
 LANGUAGE sql
AS $function$
SELECT depagentid, depagent 
FROM ndb.depagenttypes
$function$
