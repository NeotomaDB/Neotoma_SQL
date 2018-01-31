CREATE OR REPLACE FUNCTION ti.getcontactstatusestable() RETURNS SETOF record
AS $$
SELECT contactstatusid, contactstatus, statusdescription
FROM ndb.contactstatuses
$$ LANGUAGE SQL;