CREATE OR REPLACE FUNCTION ap.getkeywords() RETURNS SETOF record
AS $$
SELECT keywordid, keyword FROM ndb.keywords
ORDER BY keyword
$$ LANGUAGE SQL;