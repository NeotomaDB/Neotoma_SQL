CREATE OR REPLACE FUNCTION ti.getelementdatasettaxagroupcount(_datasettypeid integer, _taxagroupid character varying, _elementtypeid integer)
 RETURNS bigint
 LANGUAGE sql
AS $function$
SELECT COUNT(elementtypeid) AS count
FROM ndb.elementdatasettaxagroups
WHERE (datasettypeid = _datasettypeid) AND (taxagroupid = _taxagroupid) AND (elementtypeid = _elementtypeid)
$function$
