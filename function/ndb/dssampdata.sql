CREATE OR REPLACE VIEW ndb.dssampdata AS
SELECT ds.datasetid,
       count(DISTINCT smp.sampleid) AS samples,
  	   count(DISTINCT dt.dataid) AS observations
FROM ndb.datasets AS ds
LEFT OUTER JOIN ndb.samples AS smp ON smp.datasetid = ds.datasetid
LEFT OUTER JOIN ndb.data    AS dt  ON dt.sampleid = smp.sampleid
GROUP BY ds.datasetid;
GRANT SELECT ON ndb.dssampdata TO neotomawsreader;
