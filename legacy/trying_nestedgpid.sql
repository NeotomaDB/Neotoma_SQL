WITH RECURSIVE gpid AS (
  SELECT *
  FROM ndb.datasets AS ds
    INNER JOIN ndb.datasetpis AS dspi ON ds.datasetid = dspi.datasetid
    INNER JOIN ndb.contacts AS ctpi ON dspi.contactid = ctpi.contactid
    INNER JOIN ndb.dslinks AS dsl ON ds.datasetid = dsl.datasetid
    INNER JOIN ndb.sites AS st ON st.siteid = dsl.siteid
    INNER JOIN ndb.datasettypes AS dst ON dst.datasettypeid = ds.datasettypeid
    INNER JOIN ndb.datasetsubmissions AS dss on ds.datasetid = dss.datasetid
    INNER JOIN ndb.contacts AS ct ON dss.contactid = ct.contactid
    INNER JOIN ndb.constituentdatabases AS cdb ON dss.databaseid = cdb.databaseid
    INNER JOIN ndb.sitegeopolitical AS sgp ON st.siteid = sgp.siteid
    INNER JOIN ndb.geopoliticalunits AS gpu ON gpu.geopoliticalid = sgp.geopoliticalid
  WHERE ((NOW()::date - dss.submissiondate::date) / 30) < 100
)

### Need to add the bit about the nested gpids:

SELECT
dss.submissiondate::date,
  (NOW()::date - dss.submissiondate::date) / 30  AS months,
  ds.datasetid,
  dst.datasettype,
  st.sitename,
  cdb.databasename,
  ct.contactname AS steward,
  string_agg(ctpi.contactname, '; ') AS investigator

FROM ndb.datasets AS ds
  INNER JOIN ndb.datasetpis AS dspi ON ds.datasetid = dspi.datasetid
  INNER JOIN ndb.contacts AS ctpi ON dspi.contactid = ctpi.contactid
  INNER JOIN ndb.dslinks AS dsl ON ds.datasetid = dsl.datasetid
  INNER JOIN ndb.sites AS st ON st.siteid = dsl.siteid
  INNER JOIN ndb.datasettypes AS dst ON dst.datasettypeid = ds.datasettypeid
  INNER JOIN ndb.datasetsubmissions AS dss on ds.datasetid = dss.datasetid
  INNER JOIN ndb.contacts AS ct ON dss.contactid = ct.contactid
  INNER JOIN ndb.constituentdatabases AS cdb ON dss.databaseid = cdb.databaseid
WHERE ((NOW()::date - dss.submissiondate::date) / 30) < 100
GROUP BY ds.datasetid, dss.submissiondate,   ds.datasetid, dst.datasettype, st.sitename, cdb.databasename, ct.contactname
ORDER BY dss.submissiondate
