CREATE OR REPLACE FUNCTION ti.getdatasetpis(_datasetid int) RETURNS SETOF record
AS $$
SELECT ndb.datasetpis.piorder, ndb.contacts.familyname, ndb.contacts.leadinginitials
FROM ndb.datasetpis INNER JOIN ndb.contacts ON ndb.datasetpis.contactid = ndb.contacts.contactid
WHERE ndb.datasetpis.datasetid = _datasetid;
$$ LANGUAGE SQL;