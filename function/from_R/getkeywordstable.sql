CREATE OR REPLACE FUNCTION ti.getkeywordstable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      keywordid, keyword
 FROM ndb.keywords;
$function$