CREATE OR REPLACE FUNCTION ti.getrelativeagescalestable()
 RETURNS SETOF ndb.relativeagescales
 LANGUAGE sql
AS $function$
SELECT *
 FROM ndb.relativeagescales;
$function$
