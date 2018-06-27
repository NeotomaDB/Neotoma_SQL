CREATE OR REPLACE FUNCTION ap.getcollectiontypes()
RETURNS TABLE(colltypeid int, colltype varchar(64)) 
AS $$
SELECT colltypeid, colltype FROM ndb.collectiontypes
ORDER BY colltype
$$ LANGUAGE SQL;