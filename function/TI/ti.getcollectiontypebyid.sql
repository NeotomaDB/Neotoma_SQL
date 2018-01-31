CREATE OR REPLACE FUNCTION ti.getcollectiontypebyid(int)
RETURNS TABLE(colltypeid int, colltype varchar(64)) AS $$
SELECT colltypeid, colltype
FROM ndb.collectiontypes
WHERE colltypeid = $1; 
$$ LANGUAGE SQL;