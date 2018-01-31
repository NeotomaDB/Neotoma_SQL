CREATE OR REPLACE FUNCTION ti.getcontactbyfamilynameandinitials(_familyname varchar(80), _initials varchar(16)) RETURNS SETOF record
AS $$
SELECT ndb.contacts.* 
FROM ndb.contacts
WHERE familyname LIKE _familyname AND leadinginitials LIKE _initials;
$$ LANGUAGE SQL;