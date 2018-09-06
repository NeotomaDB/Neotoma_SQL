CREATE OR REPLACE FUNCTION ti.getelementtaxagroupstable()
 RETURNS TABLE(elementtaxagroupid integer, taxagroupid character varying, elementtypeid integer)
 LANGUAGE sql
AS $function$
SELECT elementtaxagroupid, taxagroupid, elementtypeid
FROM ndb.elementtaxagroups
$function$
