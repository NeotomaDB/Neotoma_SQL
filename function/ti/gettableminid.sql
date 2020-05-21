CREATE OR REPLACE FUNCTION ti.gettableminid(_tablename character varying, _columnname character varying)
 RETURNS TABLE(minid integer)
 LANGUAGE plpgsql
AS $function$
DECLARE minid int;
BEGIN
  RETURN QUERY EXECUTE format(
    'SELECT MIN(%s) as minid FROM %s', _columnname, _tablename);
END;
$function$
