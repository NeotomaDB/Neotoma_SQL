CREATE OR REPLACE FUNCTION ti.getdataprocessor(_datasetid int) RETURNS SETOF record
AS $$
SELECT ndb.contacts.contactid, ndb.contacts.aliasid, ndb.contacts.contactname, ndb.contacts.contactstatusid, ndb.contacts.familyname, 
       ndb.contacts.leadinginitials, ndb.contacts.givennames, ndb.contacts.suffix, ndb.contacts.title, ndb.contacts.phone, ndb.contacts.fax, ndb.contacts.email, 
       ndb.contacts.url, ndb.contacts.address, ndb.contacts.notes
FROM ndb.dataprocessors INNER JOIN ndb.contacts on ndb.dataprocessors.contactid = ndb.contacts.contactid
WHERE ndb.dataprocessors.datasetid = _datasetid;
$$ LANGUAGE SQL;