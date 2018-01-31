CREATE OR REPLACE FUNCTION ti.getcollectiontypestable()
RETURNS TABLE(colltypeid int, colltype varchar(64)) AS $$
SELECT colltypeid, colltype
FROM ndb.collectiontypes; 
$$ LANGUAGE SQL;