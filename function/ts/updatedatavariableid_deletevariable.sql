CREATE OR REPLACE FUNCTION ts.updatedatavariableid_deletevariable(_savevarid integer, _delvarid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.data
	SET   variableid = _savevarid
	WHERE variableid = _delvarid;

  DELETE FROM ndb.variables
  WHERE variableid = _delvarid;
$function$
