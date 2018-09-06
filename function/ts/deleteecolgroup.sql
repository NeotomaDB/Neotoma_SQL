CREATE OR REPLACE FUNCTION ts.deleteecolgroup (_taxonid integer, _ecolsetid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.ecolgroups AS eg
WHERE eg.taxonid = _taxonid AND eg.ecolsetid = _ecolsetid;
$function$
