CREATE OR REPLACE FUNCTION ti.getcontactstatusestable()
RETURNS TABLE(contactstatusid int, contactstatus varchar(16), statusdescription varchar(255))
AS $$
SELECT contactstatusid, contactstatus, statusdescription
FROM ndb.contactstatuses
$$ LANGUAGE SQL;