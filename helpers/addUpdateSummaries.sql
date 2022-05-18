CREATE TABLE IF NOT EXISTS ap.summaries (
    dbdate date PRIMARY KEY,
    sites bigint,
    datasets bigint,
    publications bigint,
    observations bigint
);

INSERT INTO ap.summaries
SELECT DISTINCT date_trunc('day', ds.recdatecreated)::date AS dbdate,
       COUNT(DISTINCT st.siteid) AS sites,
       COUNT(DISTINCT ds.datasetid) AS datasets,
	   COUNT(DISTINCT pu.publicationid) AS publications,
	   COUNT(DISTINCT dt.dataid) AS observations
FROM ndb.sites AS st
INNER JOIN ndb.collectionunits AS cu ON cu.siteid = st.siteid
INNER JOIN ndb.datasets AS ds ON ds.collectionunitid = cu.collectionunitid
INNER JOIN ndb.datasetpublications AS dspu ON dspu.datasetid = ds.datasetid
INNER JOIN ndb.publications AS pu ON pu.publicationid = dspu.publicationid
INNER JOIN ndb.analysisunits AS au ON au.collectionunitid = cu.collectionunitid
INNER JOIN ndb.samples AS smp ON smp.analysisunitid = au.analysisunitid
INNER JOIN ndb.data AS dt ON dt.sampleid = smp.sampleid
GROUP BY date_trunc('day', ds.recdatecreated);

-- The job to be added to a chron element:

INSERT INTO ap.summaries
SELECT DISTINCT date_trunc('day', ds.recdatecreated)::date AS dbdate,
       COUNT(DISTINCT st.siteid) AS sites,
       COUNT(DISTINCT ds.datasetid) AS datasets,
	   COUNT(DISTINCT pu.publicationid) AS publications,
	   COUNT(DISTINCT dt.dataid) AS observations
FROM ndb.sites AS st
INNER JOIN ndb.collectionunits AS cu ON cu.siteid = st.siteid
INNER JOIN ndb.datasets AS ds ON ds.collectionunitid = cu.collectionunitid
INNER JOIN ndb.datasetpublications AS dspu ON dspu.datasetid = ds.datasetid
INNER JOIN ndb.publications AS pu ON pu.publicationid = dspu.publicationid
INNER JOIN ndb.analysisunits AS au ON au.collectionunitid = cu.collectionunitid
INNER JOIN ndb.samples AS smp ON smp.analysisunitid = au.analysisunitid
INNER JOIN ndb.data AS dt ON dt.sampleid = smp.sampleid
WHERE ds.recdatecreated > current_date - interval '2' day
GROUP BY date_trunc('day', ds.recdatecreated)
ON CONFLICT (dbdate) DO UPDATE
  SET sites = EXCLUDED.sites,
      datasets = EXCLUDED.datasets,
      publications = EXCLUDED.publications,
      observations = EXCLUDED.observations;