CREATE OR REPLACE FUNCTION getstatsdatasetcountsandrecords()
RETURNS TABLE
(
  datasettype character varying,
  datasetcount integer,
  datarecordcount integer
) AS $$

SELECT dst.datasettype AS datasettype,
       COUNT(DISTINCT ds.datasetid) AS datasetcount,
       COUNT(ds.datasetid) AS datarecordcount
FROM
  ndb.datasets AS ds
  INNER JOIN ndb.datasettypes AS dst ON dst.datasettypeid = ds.datasettypeid
  INNER JOIN ndb.dsdatasample   AS dsd ON     dsd.datasetid = ds.datasetid
GROUP BY dst.datasettype
UNION ALL
SELECT 'geochronological' AS datasettype,
       COUNT(DISTINCT ds.datasetid) AS datasetcount,
       COUNT(ds.datasetid) AS datarecordcount
FROM
  ndb.geochronology AS gch
  INNER JOIN ndb.samples AS sm ON gch.sampleid = sm.sampleid
  INNER JOIN ndb.datasets AS ds ON sm.datasetid = ds.datasetid
$$ LANGUAGE SQL;
