CREATE OR REPLACE FUNCTION ts.updatesamplelabnumber(_sampleid integer, _labnumber character varying DEFAULT NULL::character varying)
 RETURNS void
 LANGUAGE sql
AS $function$

  UPDATE ndb.samples AS smp
  SET labnumber = CASE WHEN (_labnumber IS NULL OR _labnumber = '') THEN null ELSE _labnumber END
  WHERE  (smp.sampleid = _sampleid)

$function$
