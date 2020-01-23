CREATE OR REPLACE FUNCTION ti.getrelativeagescalestable()
 RETURNS TABLE(relativeagescaleid int, relativeagescale character varying) 
 LANGUAGE sql
AS $function$
SELECT relativeagescaleid, relativeagescale
 FROM ndb.relativeagescales;
$function$
