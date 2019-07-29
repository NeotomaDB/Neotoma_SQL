CREATE OR REPLACE FUNCTION ts.updatedatavariableid(_oldvariableid integer, _newvariableid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.data
	SET   variableid = _newvariableid
	WHERE variableid = _oldvariableid
$function$
