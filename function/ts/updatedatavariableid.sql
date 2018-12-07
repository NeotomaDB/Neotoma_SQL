CREATE OR REPLACE FUNCTION ts.updatedatavariableid(
  _oldvariableid integer,
  _newvariableid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.data AS dt
	SET   dt.variableid = _newvariableid
	WHERE dt.variableid = _oldvariableid
$function$;
