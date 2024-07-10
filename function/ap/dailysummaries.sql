CREATE or REPLACE FUNCTION ap.dailysummaries(_interval VARCHAR DEFAULT '1')
RETURNS TABLE (dbdate DATE, sites BIGINT, datasets BIGINT, publications BIGINT, observations BIGINT)
AS $$
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
WHERE ds.recdatecreated > current_date - (_interval || 'day')::INTERVAL
GROUP BY date_trunc('day', ds.recdatecreated)
$$ LANGUAGE sql;