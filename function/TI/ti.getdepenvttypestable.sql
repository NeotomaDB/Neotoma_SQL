CREATE OR REPLACE FUNCTION ti.getdepenvttypestable()
RETURNS TABLE(depenvtid int, depenvt varchar(255), depenvthigherid int)
AS $$
SELECT depenvtid, depenvt, depenvthigherid
FROM ndb.depenvttypes
$$ LANGUAGE SQL;