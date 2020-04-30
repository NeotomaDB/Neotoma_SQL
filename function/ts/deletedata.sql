CREATE OR REPLACE FUNCTION ts.deletedata(_dataid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  DELETE FROM ndb.data AS da
  WHERE da.dataid = _dataid;
$function$
