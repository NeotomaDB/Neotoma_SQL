CREATE OR REPLACE FUNCTION ts.deletesample (_sampleid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
DELETE FROM ndb.samples AS sms
WHERE sms.sampleid = _sampleid;
$function$
