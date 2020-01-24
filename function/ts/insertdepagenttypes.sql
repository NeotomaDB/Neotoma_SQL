CREATE OR REPLACE FUNCTION ts.insertdepagenttypes(_depagent character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.depagenttypes(depagent)
  VALUES (_depagent)
  RETURNING depagentid
$function$
