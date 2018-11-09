CREATE OR REPLACE FUNCTION doi.inds(dsid integer)
RETURNS boolean
AS $$
  SELECT COUNT(*) = 1 FROM
  ndb.datasets AS ds
  WHERE ds.datasetid = dsid;
$$ LANGUAGE SQL;
