-- Datasets by database as a data processor.
SELECT COUNT(qt.datasetid), cdb.databasename, DATE_TRUNC('year', ds.recdatecreated)
FROM  ap.querytable AS qt
INNER JOIN ndb.datasets as ds ON ds.datasetid = qt.datasetid
INNER JOIN ndb.constituentdatabases AS cdb ON qt.databaseid = cdb.databaseid
INNER JOIN ndb.dataprocessors AS dp ON dp.datasetid = qt.datasetid
INNER JOIN ndb.contacts AS ct ON ct.contactid = dp.contactid
WHERE ct.familyname = 'Cullen'
GROUP BY DATE_TRUNC('year', ds.recdatecreated), qt.databaseid, cdb.databasename
ORDER BY DATE_TRUNC('year', ds.recdatecreated), qt.databaseid;

--Chronologies constructed
SELECT COUNT(ch.chronologyid), DATE_TRUNC('year', ch.recdatecreated)
FROM ndb.chronologies AS ch 
INNER JOIN ndb.contacts AS ct on ct.contactid = ch.contactid
WHERE ct.familyname = 'Cullen'
GROUP BY DATE_TRUNC('year', ch.recdatecreated)
ORDER BY DATE_TRUNC('year', ch.recdatecreated);

--datasets submitted
SELECT COUNT(qt.datasetid), cdb.databasename, DATE_TRUNC('year', ds.recdatecreated)
FROM  ap.querytable AS qt
INNER JOIN ndb.datasets as ds ON ds.datasetid = qt.datasetid
INNER JOIN ndb.constituentdatabases AS cdb ON qt.databaseid = cdb.databaseid
INNER JOIN ndb.datasetsubmissions AS dsm ON dsm.datasetid = qt.datasetid
INNER JOIN ndb.contacts AS ct ON ct.contactid = dsm.contactid
WHERE ct.familyname = 'Cullen'
GROUP BY DATE_TRUNC('year', ds.recdatecreated), qt.databaseid, cdb.databasename
ORDER BY DATE_TRUNC('year', ds.recdatecreated), qt.databaseid;
