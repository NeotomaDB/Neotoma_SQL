CREATE OR REPLACE FUNCTION ti.getelementtypebydatasettypeid(_datasettypeid integer)
 RETURNS TABLE(elementtypeid integer, elementtype character varying, taxagroupid character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.elementtypes.elementtypeid, ndb.elementtypes.elementtype, ndb.elementdatasettaxagroups.taxagroupid
FROM ndb.elementdatasettaxagroups INNER JOIN ndb.elementtypes
	ON ndb.elementdatasettaxagroups.elementtypeid = ndb.elementtypes.elementtypeid
WHERE ndb.elementdatasettaxagroups.datasettypeid = 5
ORDER BY ndb.elementdatasettaxagroups.taxagroupid, ndb.elementtypes.elementtype;
$function$
