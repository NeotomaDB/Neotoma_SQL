CREATE OR REPLACE FUNCTION ti.getrelativeageunitsbyname(_relativeagescale character varying)
 RETURNS TABLE(relativeagescaleid integer, relativeagescale character varying)
 LANGUAGE sql
AS $function$
SELECT     ras.relativeagescaleid,
            ras.relativeagescale
FROM       ndb.relativeagescales AS ras
WHERE (ras.relativeagescale ILIKE _relativeagescale)
$function$
