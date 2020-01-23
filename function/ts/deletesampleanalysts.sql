CREATE OR REPLACE FUNCTION ts.deletesampleanalysts(_sampleid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.sampleanalysts AS sas
WHERE sas.sampleid = _sampleid;
$function$
