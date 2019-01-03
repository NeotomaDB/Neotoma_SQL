CREATE OR REPLACE FUNCTION ti.getelementtypebydatasettypeid(_datasettypeid integer)
 RETURNS TABLE(elementtypeid integer, elementtype character varying, taxagroupid character varying)
 LANGUAGE sql
AS $function$
SELECT ets.elementtypeid, ets.elementtype, edg.taxagroupid
FROM ndb.elementdatasettaxagroups AS edg INNER JOIN ndb.elementtypes AS ets
	ON edg.elementtypeid = ets.elementtypeid
WHERE edg.datasettypeid = 5
ORDER BY edg.taxagroupid, ets.elementtype;
$function$
