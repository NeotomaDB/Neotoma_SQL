CREATE OR REPLACE FUNCTION ti.getelementtypebyname(_elementtype character varying)
 RETURNS TABLE(elementtypeid integer, elementtype character varying)
 LANGUAGE sql
AS $function$

SELECT elementtypeid, elementtype
FROM ndb.elementtypes
WHERE elementtype ILIKE _elementtype

$function$
