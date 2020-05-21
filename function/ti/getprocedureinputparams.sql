CREATE OR REPLACE FUNCTION ti.getprocedureinputparams(_procedurename character varying)
 RETURNS TABLE(name character varying, type character varying, isdefault boolean, paramorder bigint)
 LANGUAGE sql
AS $function$

  SELECT (string_to_array(trim(leading from t.nametype), ' '))[1] AS name,
      REGEXP_REPLACE(array_to_string((string_to_array(trim(leading from t.nametype), ' '))[2:],' '), ' DE.*', '') AS type,
      t.nametype ILIKE '%DEFAULT%' AS default,
      t."order"
  FROM (
    SELECT * FROM
    unnest(string_to_array(pg_catalog.pg_get_function_arguments(LOWER(_procedurename)::regproc::oid),','))
    WITH ORDINALITY a(nametype,"order")
  ) AS t;

$function$
