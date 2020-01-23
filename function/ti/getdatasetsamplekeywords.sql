CREATE OR REPLACE FUNCTION ti.getdatasetsamplekeywords(_datasetid integer)
 RETURNS TABLE(sampleid integer, keyword character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.samplekeywords.sampleid, ndb.keywords.keyword
FROM ndb.samples inner join
     ndb.samplekeywords ON ndb.samples.sampleid = ndb.samplekeywords.sampleid INNER JOIN
     ndb.keywords ON ndb.samplekeywords.keywordid = ndb.keywords.keywordid
WHERE ndb.samples.datasetid = _datasetid;
$function$
