CREATE OR REPLACE FUNCTION ti.getdepenvtbyid(_depenvtid int)
RETURNS TABLE(depenvtid int, depenvt varchar(255), depenvthigherid int)
AS $$
SELECT depenvtid, depenvt, depenvthigherid
FROM ndb.depenvttypes
WHERE depenvtid = _depenvtid 
$$ LANGUAGE SQL;