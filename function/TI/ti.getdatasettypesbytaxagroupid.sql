CREATE OR REPLACE FUNCTION ti.getdatasettypesbytaxagroupid(_taxagroupid varchar(3))
RETURNS TABLE(datasettypeid int, datasettype varchar(64))
AS $$ 
SELECT ndb.datasettaxagrouptypes.datasettypeid, ndb.datasettypes.datasettype
FROM ndb.datasettaxagrouptypes INNER JOIN
		ndb.datasettypes on ndb.datasettaxagrouptypes.datasettypeid = ndb.datasettypes.datasettypeid
WHERE ndb.datasettaxagrouptypes.taxagroupid = _taxagroupid
$$ LANGUAGE SQL;