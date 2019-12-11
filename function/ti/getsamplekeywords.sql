CREATE OR REPLACE FUNCTION ti.getsamplekeywords(_sampleid int)
RETURNS TABLE(keywordid integer, keyword varchar)
LANGUAGE sql
AS $function$

SELECT ndb.samplekeywords.keywordid, ndb.keywords.keyword
FROM ndb.samplekeywords INNER JOIN
	ndb.keywords ON ndb.samplekeywords.keywordid = ndb.keywords.keywordid
WHERE ndb.samplekeywords.sampleid = _sampleid

$function$