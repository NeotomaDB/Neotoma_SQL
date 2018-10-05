CREATE OR REPLACE FUNCTION ts.insertdepagenttypes(_depagent character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.depagenttypes(depagent)
VALUES (_depagent)
RETURNING depagentid
$function$;
