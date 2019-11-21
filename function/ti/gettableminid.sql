CREATE OR REPLACE FUNCTION ti.gettableminid(_tablename character varying, _columnname character varying)
 RETURNS TABLE(minid INTEGER)
 LANGUAGE plpgsql
AS $function$
DECLARE minid int;
BEGIN
  RETURN QUERY
  EXECUTE format(
    'SELECT min(%s) as minid FROM %s', _columnname, _tablename)
	INTO minid;
END;
$function$
