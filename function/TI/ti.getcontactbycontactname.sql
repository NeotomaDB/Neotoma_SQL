CREATE OR REPLACE FUNCTION ti.getcontactbycontactname(_contactname varchar(80))
RETURNS TABLE(contactid int, aliasid int, contactname varchar(80), contactstatusid int, familyname varchar(80), leadinginitials varchar(16),
			givennames varchar(80), suffix varchar(16), title varchar(16), phone varchar(64), fax varchar(64), email varchar(64), url varchar(255), address text, notes text)
AS $$
SELECT contactid, aliasid, contactname, contactstatusid, familyname, leadinginitials, givennames, suffix, title, phone, fax, email, url, address, notes
FROM ndb.contacts
WHERE contactname = _contactname;
$$ LANGUAGE SQL;