CREATE OR REPLACE FUNCTION ti.getdatasettypes()
RETURNS TABLE(datasettypeid int, datasettype varchar(64))
AS $$
SELECT datasettypeid, datasettype
FROM ndb.datasettypes 
$$ LANGUAGE SQL;