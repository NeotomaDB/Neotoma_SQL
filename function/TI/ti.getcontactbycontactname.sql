CREATE OR REPLACE FUNCTION ti.getcontactbycontactname(_contactname varchar(80)) RETURNS SETOF record
AS $$
SELECT contactid, aliasid, contactname, contactstatusid, familyname, leadinginitials, givennames, suffix, title, phone, fax, email, url, address, notes
FROM ndb.contacts
WHERE contactname = _contactname;
$$ LANGUAGE SQL;