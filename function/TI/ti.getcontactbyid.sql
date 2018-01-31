CREATE OR REPLACE FUNCTION ti.getcontactbyid(_contactid int) RETURNS SETOF record
AS $$
SELECT contactid, aliasid, contactname, contactstatusid, familyname, leadinginitials, givennames, suffix, title, phone, fax, email, url, address, notes
FROM ndb.contacts
WHERE contactid = _contactid;
$$ LANGUAGE SQL;