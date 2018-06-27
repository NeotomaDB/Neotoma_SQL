CREATE OR REPLACE FUNCTION ti.getdatasettaxonnotesbytaxonid(_datasetid int, _taxonid int)
RETURNS TABLE(taxonid int, taxonname varchar(80), notes text)
AS $$
SELECT ndb.datasettaxonnotes.taxonid, ndb.taxa.taxonname, ndb.datasettaxonnotes.notes
FROM ndb.datasettaxonnotes INNER JOIN ndb.taxa ON ndb.datasettaxonnotes.taxonid = ndb.taxa.taxonid
WHERE ndb.datasettaxonnotes.datasetid = _datasetid AND ndb.datasettaxonnotes.taxonid = _taxonid
$$ LANGUAGE SQL;