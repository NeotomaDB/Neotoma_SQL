CREATE OR REPLACE FUNCTION ti.getelementdatasettaxagroupcount(_datasettypeid integer, _taxagroupid character varying, _elementtypeid integer)
 RETURNS TABLE(count integer)
 LANGUAGE sql
AS $function$
  SELECT COUNT(edt.elementtypeid)::INTEGER AS count
  FROM ndb.elementdatasettaxagroups AS edt
  WHERE (edt.datasettypeid = _datasettypeid) AND (edt.taxagroupid = _taxagroupid) AND (elementtypeid = _elementtypeid);
$function$
