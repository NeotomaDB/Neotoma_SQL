CREATE OR REPLACE FUNCTION ti.getelementtypestable()
 RETURNS TABLE(elementtypeid integer, elementtype text)
 LANGUAGE sql
AS $function$
SELECT
  elementtypeid,
  elementtype
FROM ndb.elementtypes;
$function$
