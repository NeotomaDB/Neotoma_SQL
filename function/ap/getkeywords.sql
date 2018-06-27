CREATE OR REPLACE FUNCTION ap.getkeywords()
 RETURNS TABLE(keywordid integer, keyword character varying)
 LANGUAGE sql
AS $function$
SELECT keywordid, keyword FROM ndb.keywords
ORDER BY keyword
$function$
