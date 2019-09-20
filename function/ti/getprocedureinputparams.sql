CREATE OR REPLACE FUNCTION ti.getprocedureinputparams(_procedurename character varying)
 RETURNS TABLE(params text)
 LANGUAGE plpgsql
AS $function$

DECLARE

	sch text := split_part(_procedurename, '.', 1);
	func text := split_part(_procedurename, '.', 2);

BEGIN

	RETURN QUERY
	SELECT unnest(regexp_split_to_array(pg_get_function_arguments(p.oid), ', ')) AS params
	FROM pg_catalog.pg_namespace n JOIN  pg_catalog.pg_proc p
	ON p.pronamespace = n.oid
	WHERE p.proname ILIKE func AND n.nspname ILIKE sch;


END;

$function$
