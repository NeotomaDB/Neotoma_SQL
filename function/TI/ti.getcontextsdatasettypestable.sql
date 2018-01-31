CREATE OR REPLACE FUNCTION ti.getcontextsdatasettypestable() RETURNS SETOF record
AS $$
SELECT ndb.contextsdatasettypes.datasettypeid, ndb.contextsdatasettypes.variablecontextid
FROM ndb.contextsdatasettypes
$$ LANGUAGE SQL;