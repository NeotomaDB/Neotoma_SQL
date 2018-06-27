CREATE FUNCTION ti.getdatasettypesbyname(_datasettype varchar(64))
RETURNS TABLE(datasettypeid int, datasettype varchar(80))
AS $$
DECLARE
	dt varchar(80) = _datasettype + '%';
BEGIN
	RETURN QUERY SELECT datasettypeid, datasettype
		FROM ndb.datasettypes
		WHERE datasettype LIKE dt;
END;
$$ LANGUAGE plpgsql;