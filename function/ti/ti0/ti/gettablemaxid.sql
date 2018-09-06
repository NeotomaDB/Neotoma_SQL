CREATE OR REPLACE FUNCTION ti.gettablemaxid(_tablename character varying, _columnname character varying)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE maxid int;
BEGIN
  EXECUTE format(
    'SELECT max(%s) as maxid FROM %s', _columnname, _tablename)
	INTO maxid;
  Return maxid;
	
END;
$function$
