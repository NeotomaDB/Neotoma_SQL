CREATE OR REPLACE FUNCTION ti.getdataprocessor(_datasetid int)
RETURNS TABLE(contactid int, aliasid int, contactname varchar(80), contactstatusid int, familyname varchar(80), leadinginitials varchar(16),
		givennames varchar(80), suffix varchar(16), title varchar(16), phone varchar(64), fax varchar(64), email varchar(64),
		url varchar(255), address text, notes text)
AS $$
SELECT ndb.contacts.contactid, ndb.contacts.aliasid, ndb.contacts.contactname, ndb.contacts.contactstatusid, ndb.contacts.familyname, 
       ndb.contacts.leadinginitials, ndb.contacts.givennames, ndb.contacts.suffix, ndb.contacts.title, ndb.contacts.phone, ndb.contacts.fax, ndb.contacts.email, 
       ndb.contacts.url, ndb.contacts.address, ndb.contacts.notes
FROM ndb.dataprocessors INNER JOIN ndb.contacts on ndb.dataprocessors.contactid = ndb.contacts.contactid
WHERE ndb.dataprocessors.datasetid = _datasetid;
$$ LANGUAGE SQL;