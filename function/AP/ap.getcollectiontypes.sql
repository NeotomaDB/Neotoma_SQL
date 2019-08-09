CREATE OR REPLACE FUNCTION ap.getcollectiontypes() RETURNS SETOF record
AS $$
SELECT colltypeid, colltype FROM ndb.collectiontypes
ORDER BY colltype
$$ LANGUAGE SQL;