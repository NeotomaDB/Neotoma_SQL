CREATE OR REPLACE FUNCTION ti.getcontactbyfamilyname(_familyname varchar(80)) RETURNS SETOF record
AS $$
SELECT contactid, aliasid, contactname, contactstatusid, familyname, leadinginitials, givennames, suffix, title, phone, fax, email, url, address, notes
FROM ndb.contacts
WHERE familyname LIKE _familyname;
$$ LANGUAGE SQL;