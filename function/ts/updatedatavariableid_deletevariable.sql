CREATE OR REPLACE FUNCTION ts.updatedatavariableid_deletevariable(
  _savevarid integer,
  _delvarid integer)
/* merges @delvarid with @savevarid and deletes @delvarid */
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.data AS dt
	SET   dt.variableid = _savevarid
	WHERE dt.variableid = _delvarid

  DELETE FROM ndb.variables as vr
  WHERE vr.variableid = _delvarid
$function$;
