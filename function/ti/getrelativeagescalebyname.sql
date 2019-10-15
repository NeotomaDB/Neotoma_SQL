CREATE OR REPLACE FUNCTION ti.getrelativeagescalebyname(_relativeagescale character varying)
RETURNS TABLE(relativeagescaleid integer, relativeagescale character varying)
LANGUAGE sql
AS $function$
SELECT relativeagescaleid, relativeagescale
FROM ndb.relativeagescales
WHERE relativeagescale = $1;
$function$

