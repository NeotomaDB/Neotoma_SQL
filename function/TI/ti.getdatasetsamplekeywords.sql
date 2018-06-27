CREATE OR REPLACE FUNCTION ti.getdatasetsamplekeywords(_datasetid int)
RETURNS TABLE(sampleid int, keyword varchar(64))
AS $$
SELECT ndb.samplekeywords.sampleid, ndb.keywords.keyword
FROM ndb.samples inner join
     ndb.samplekeywords ON ndb.samples.sampleid = ndb.samplekeywords.sampleid INNER JOIN
     ndb.keywords ON ndb.samplekeywords.keywordid = ndb.keywords.keywordid
WHERE ndb.samples.datasetid = _datasetid;
$$ LANGUAGE SQL;