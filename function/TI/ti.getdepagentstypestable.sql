CREATE OR REPLACE FUNCTION ti.getdepagentstypestable() 
RETURNS TABLE(depagentid int, depagent varchar(64))
AS $$
SELECT depagentid, depagent 
FROM ndb.depagenttypes
$$ LANGUAGE SQL;