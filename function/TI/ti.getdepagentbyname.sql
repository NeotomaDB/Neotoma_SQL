CREATE OR REPLACE FUNCTION ti.getdepagentbyname(_depagent varchar(64))
RETURNS TABLE(depagentid int, depagent varchar(64))
AS $$ 
SELECT depagentid, depagent 
FROM ndb.depagenttypes
WHERE depagent = _depagent
$$ LANGUAGE SQL;