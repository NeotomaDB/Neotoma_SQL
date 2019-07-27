CREATE OR REPLACE FUNCTION ts.deletevariablecontext(_variablecontextid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
delete from ndb.variablecontexts AS vcx
where vcx.variablecontextid = _variablecontextid
$function$
