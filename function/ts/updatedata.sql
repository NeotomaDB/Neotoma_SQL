CREATE OR REPLACE FUNCTION ts.updatedata(_dataid integer, _value float)
	RETURNS void
	LANGUAGE sql
AS $function$
	UPDATE ndb.data AS da
	SET    value = _value
	WHERE  da.dataid = _dataid
$function$;
