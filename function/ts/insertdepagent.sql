CREATE OR REPLACE FUNCTION ts.insertdepagent(_analysisunitid integer, _depagentid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.depagents(analysisunitid, depagentid)
VALUES (_analysisunitid, _depagentid)
$function$;
