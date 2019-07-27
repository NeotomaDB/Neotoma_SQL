CREATE OR REPLACE FUNCTION ts.deletevariablebyvariableid(_variableid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
delete from ndb.variables AS vbs
where vbs.variableid = _variableid
$function$
