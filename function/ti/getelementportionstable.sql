CREATE OR REPLACE FUNCTION ti.getelementportionstable()
 RETURNS TABLE(portionid integer, portion character varying)
 LANGUAGE sql
AS $function$
SELECT portionid, portion
FROM ndb.elementportions
$function$
