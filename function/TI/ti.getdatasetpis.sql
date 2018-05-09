CREATE OR REPLACE FUNCTION ti.getdatasetpis(_datasetid int)
RETURNS TABLE(piorder int, familyname varchar(80), leadinginitials varchar(16))
AS $$
SELECT ndb.datasetpis.piorder, ndb.contacts.familyname, ndb.contacts.leadinginitials
FROM ndb.datasetpis INNER JOIN ndb.contacts ON ndb.datasetpis.contactid = ndb.contacts.contactid
WHERE ndb.datasetpis.datasetid = _datasetid;
$$ LANGUAGE SQL;