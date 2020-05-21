CREATE OR REPLACE FUNCTION ti.getelementtypesbynamelist(_elementtypes character varying)
 RETURNS TABLE(elementtypeid integer, elementtype character varying)
 LANGUAGE sql
AS $function$

SELECT elementtypeid, elementtype
FROM ndb.elementtypes
WHERE lower(elementtype) IN (SELECT unnest(string_to_array(lower(_elementtypes),'$'))::varchar)

$function$
