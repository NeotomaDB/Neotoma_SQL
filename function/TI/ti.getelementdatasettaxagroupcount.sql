CREATE OR REPLACE FUNCTION ti.getelementdatasettaxagroupcount(_datasettypeid int, _taxagroupid varchar(3), _elementtypeid int)
RETURNS bigint
AS $$
SELECT COUNT(elementtypeid) AS count
FROM ndb.elementdatasettaxagroups
WHERE (datasettypeid = _datasettypeid) AND (taxagroupid = _taxagroupid) AND (elementtypeid = _elementtypeid)
$$ LANGUAGE SQL;