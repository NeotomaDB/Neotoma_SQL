WITH agelimits AS (
  SELECT *
  FROM (VALUES (1, -extract( year FROM CURRENT_DATE )::int),
              (2, (1950 - extract( year FROM CURRENT_DATE )::int)),
              (3, (1950 - extract( year FROM CURRENT_DATE )::int)),
              (4, (1950 - extract( year FROM CURRENT_DATE )::int)),
              (5, 0)) AS t (agetypeid, maxage)
)
SELECT ds.datasetid,
       st.sitename,
       ch.chronologyid,
       ch.chronologyname,
       ch.isdefault,
       (CASE
         WHEN at.agetypeid = 1
          THEN -ch.ageboundyounger
          ELSE ch.ageboundyounger
          END) AS ageboundyounger,
       al.maxage AS agetypeyoungflag,
       at.agetype
FROM ndb.collectionunits AS cu
INNER JOIN ndb.sites AS st ON cu.siteid = st.siteid
INNER JOIN ndb.datasets AS ds ON ds.collectionunitid = cu.collectionunitid
INNER JOIN ndb.chronologies AS ch ON ch.collectionunitid = cu.collectionunitid
INNER JOIN ndb.agetypes AS at ON at.agetypeid = ch.agetypeid
INNER JOIN (SELECT * FROM agelimits) AS al ON al.agetypeid = ch.agetypeid
WHERE ch.ageboundyounger < al.maxage - 5
