CREATE OR REPLACE FUNCTION ti.getprocedureinputparams(_procedurename character varying)
 RETURNS TABLE(name character varying,
               type character varying,
               isdefault boolean,
               paramorder bigint)
 LANGUAGE sql
AS $function$
WITH params AS (
	SELECT  _procedurename AS procname,
			regexp_split_to_array(oidvectortypes(p.proargtypes), ', ') AS argtypes,
			p.proargnames AS argnames,
			regexp_split_to_array(pg_get_expr(p.proargdefaults,0), ',') AS isdefault
		FROM pg_catalog.pg_namespace AS n
		  JOIN  pg_catalog.pg_proc p
		ON p.pronamespace = n.oid
		WHERE p.proname ILIKE split_part(_procedurename, '.', 2) AND n.nspname ILIKE split_part(_procedurename, '.', 1))
    SELECT u.name,
           u.type,
           u.def IS NOT NULL AS default,
           ROW_NUMBER() OVER (ORDER BY name) AS order
    FROM  unnest((SELECT argtypes FROM params), (SELECT argnames FROM params),(SELECT isdefault FROM params)) AS u(type, name, def)
    WHERE type IS NOT NULL
$function$
