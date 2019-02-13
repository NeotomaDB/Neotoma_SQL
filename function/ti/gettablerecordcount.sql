CREATE OR REPLACE FUNCTION ti.gettablerecordcount(_tablename character varying)
 RETURNS TABLE(count integer)
 LANGUAGE plpgsql
AS $function$

BEGIN
  RETURN QUERY
  EXECUTE format(
  	'SELECT count(*)::integer as count FROM ndb.' || '%s', _tablename);
END;

$function$
