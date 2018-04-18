CREATE OR REPLACE FUNCTION ap.getkeywords()
RETURNS TABLE(keywordid int, keyword varchar(64)) 
AS $$
SELECT keywordid, keyword FROM ndb.keywords
ORDER BY keyword
$$ LANGUAGE SQL;