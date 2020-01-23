CREATE OR REPLACE FUNCTION ti.gettablemaxid(_tablename character varying, _columnname character varying)
 RETURNS TABLE(maxid INTEGER)
 LANGUAGE plpgsql
AS $function$
DECLARE maxid int;
BEGIN
  RETURN QUERY EXECUTE format(
    'SELECT MAX(%s) as maxid FROM %s', _columnname, _tablename);
END;
$function$
