CREATE OR REPLACE FUNCTION ti.getdepagentbyname(_depagent character varying)
 RETURNS TABLE(depagentid integer, depagent character varying)
 LANGUAGE sql
AS $function$ 
SELECT depagentid, depagent 
FROM ndb.depagenttypes
WHERE depagent ILIKE _depagent;
$function$
