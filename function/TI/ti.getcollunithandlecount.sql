CREATE OR REPLACE FUNCTION ti.getcollunithandlecount(hand varchar(10)) RETURNS bigint
AS $$
SELECT COUNT(handle) AS count
FROM ndb.collectionunits
WHERE handle = hand;
$$ LANGUAGE SQL;