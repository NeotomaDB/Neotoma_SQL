CREATE OR REPLACE FUNCTION ti.getecolsettypestable()
RETURNS TABLE(ecolsetid int, ecolsetname varchar(64))
AS $$
SELECT ecolsetid, ecolsetname
FROM ndb.ecolsettypes
$$ LANGUAGE SQL;