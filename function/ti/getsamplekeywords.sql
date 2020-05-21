CREATE OR REPLACE FUNCTION ti.getsamplekeywords(_sampleid integer)
 RETURNS TABLE(keywordid integer, keyword character varying)
 LANGUAGE sql
AS $function$

SELECT ndb.samplekeywords.keywordid, ndb.keywords.keyword
FROM ndb.samplekeywords INNER JOIN
	ndb.keywords ON ndb.samplekeywords.keywordid = ndb.keywords.keywordid
WHERE ndb.samplekeywords.sampleid = _sampleid

$function$
