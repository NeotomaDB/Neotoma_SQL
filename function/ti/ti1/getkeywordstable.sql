CREATE OR REPLACE FUNCTION ti.getkeywordstable()
 RETURNS TABLE(keywordid integer, keyword character varying)
 LANGUAGE sql
AS $function$
SELECT      keywordid, keyword
 FROM ndb.keywords;
$function$
