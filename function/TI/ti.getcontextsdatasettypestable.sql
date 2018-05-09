CREATE OR REPLACE FUNCTION ti.getcontextsdatasettypestable()
RETURNS TABLE(datasettypeid int, variablecontextid int)
AS $$
SELECT ndb.contextsdatasettypes.datasettypeid, ndb.contextsdatasettypes.variablecontextid
FROM ndb.contextsdatasettypes
$$ LANGUAGE SQL;