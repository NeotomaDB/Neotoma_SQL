CREATE OR REPLACE FUNCTION ap.pg_stat_statements_reset()
 RETURNS void
 LANGUAGE c
 PARALLEL SAFE
AS '$libdir/pg_stat_statements', $function$pg_stat_statements_reset$function$
