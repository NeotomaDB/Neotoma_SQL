CREATE OR REPLACE FUNCTION ap.updatequery()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
REFRESH MATERIALIZED VIEW CONCURRENTLY ap.querytable;
RETURN NULL;
END $function$
