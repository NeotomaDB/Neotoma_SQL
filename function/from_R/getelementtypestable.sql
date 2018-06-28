CREATE OR REPLACE FUNCTION ti.getelementtypestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT       elementtypeid, elementtype
 FROM ndb.elementtypes;
$function$