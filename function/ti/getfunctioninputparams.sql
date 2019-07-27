CREATE OR REPLACE FUNCTION ti.getfunctioninputparams(_functionname character varying)
 RETURNS TABLE(name character varying, type character varying, "order" bigint)
 LANGUAGE sql
AS $function$

SELECT (string_to_array(trim(leading from t.nametype), ' '))[1] AS name,
		array_to_string((string_to_array(trim(leading from t.nametype), ' '))[2:],' ') AS type,
		t."order"
FROM (
	SELECT * FROM unnest(string_to_array(pg_catalog.pg_get_function_identity_arguments(('ti.' || _functionname)::regproc::oid),','))
	WITH ORDINALITY a(nametype,"order")
) AS t;


$function$
