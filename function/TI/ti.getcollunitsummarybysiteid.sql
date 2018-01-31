CREATE OR REPLACE FUNCTION ti.getcollunitsummarybysiteid(_siteid int) RETURNS SETOF record
AS $$
SELECT ndb.collectionunits.collectionunitid, ndb.collectionunits.handle, ndb.collectionunits.collunitname, ndb.collectiontypes.colltype, 
       ndb.collectionunits.colldate::varchar(10) AS colldate
FROM ndb.collectionunits INNER JOIN ndb.collectiontypes ON ndb.collectionunits.colltypeid = ndb.collectiontypes.colltypeid
WHERE ndb.collectionunits.siteid = _siteid;
$$ LANGUAGE SQL;