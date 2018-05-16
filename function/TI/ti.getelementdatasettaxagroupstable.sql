CREATE OR REPLACE FUNCTION ti.getelementdatasettaxagroupstable()
RETURNS TABLE(datasettypeid int, taxagroupid varchar(3), elementtypeid int)
AS $$
SELECT datasettypeid, taxagroupid, elementtypeid
FROM ndb.elementdatasettaxagroups
ORDER BY datasettypeid, taxagroupid, elementtypeid
$$ LANGUAGE SQL;