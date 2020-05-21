CREATE OR REPLACE FUNCTION ti.getelementportionbyname(_portion character varying)
 RETURNS TABLE(portionid integer, portion character varying)
 LANGUAGE sql
AS $function$
SELECT portionid, portion
FROM ndb.elementportions
WHERE portion ILIKE $1
$function$
