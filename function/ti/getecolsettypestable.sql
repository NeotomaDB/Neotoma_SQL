CREATE OR REPLACE FUNCTION ti.getecolsettypestable()
 RETURNS TABLE(ecolsetid integer, ecolsetname character varying)
 LANGUAGE sql
AS $function$
SELECT ecolsetid, ecolsetname
FROM ndb.ecolsettypes
$function$
