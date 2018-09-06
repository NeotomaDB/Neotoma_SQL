CREATE OR REPLACE FUNCTION ti.gettableminid(_tablename character varying, _columnname character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE minid int;
BEGIN
  EXECUTE format(
    'SELECT min(%s) as minid FROM %s', _columnname, _tablename)
	INTO minid;
  Return minid;
	
END;
$function$
