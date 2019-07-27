CREATE OR REPLACE FUNCTION ti.getecolgrouptypestable()
 RETURNS TABLE(ecolgroupid character varying, ecolgroup character varying)
 LANGUAGE sql
AS $function$
SELECT ecolgroupid, ecolgroup
FROM ndb.ecolgrouptypes
$function$
