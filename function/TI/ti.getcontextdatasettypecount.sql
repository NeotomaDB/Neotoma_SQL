CREATE OR REPLACE FUNCTION ti.getcontextdatasettypecount(_datasettypeid int, _variablecontextid int) RETURNS bigint
AS $$
SELECT COUNT(datasettypeid) AS count
FROM ndb.contextsdatasettypes
WHERE datasettypeid = _datasettypeid AND variablecontextid = _variablecontextid;
$$ LANGUAGE SQL;