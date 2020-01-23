CREATE OR REPLACE FUNCTION ti.getelementdatasettaxagroupstable()
 RETURNS TABLE(datasettypeid integer, taxagroupid character varying, elementtypeid integer)
 LANGUAGE sql
AS $function$
SELECT datasettypeid, taxagroupid, elementtypeid
FROM ndb.elementdatasettaxagroups
ORDER BY datasettypeid, taxagroupid, elementtypeid
$function$
