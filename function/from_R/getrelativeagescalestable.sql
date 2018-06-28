CREATE OR REPLACE FUNCTION ti.getrelativeagescalestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       ndb.relativeagescales.*
 FROM ndb.relativeagescales;
$function$