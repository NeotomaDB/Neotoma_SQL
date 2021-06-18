WITH lithos AS (
  SELECT st.siteid,
         cu.collectionunitid,
         COUNT(lt.lithologyid)
  FROM ndb.lithology AS lt
  INNER JOIN ndb.collectionunits AS cu ON cu.collectionunitid = lt.collectionunitid
  INNER JOIN ndb.sites AS st ON st.siteid = cu.siteid
  GROUP BY st.siteid, cu.collectionunitid)
SELECT li.siteid,
       dsl.datasetid,
       COUNT(*) FROM lithos AS li
INNER JOIN ndb.dslinks AS dsl ON dsl.siteid = li.siteid
INNER JOIN ndb.datasetdatabases AS dsdb ON dsdb.datasetid = dsl.datasetid
WHERE dsdb.databaseid = 3
GROUP BY siteid
HAVING COUNT(*) > 1
