CREATE OR REPLACE FUNCTION ts.insertecolgrouptype(_ecolgroupid character varying, _ecolgroup character varying)
 RETURNS character varying
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.ecolgrouptypes(ecolgroupid, ecolgroup)
  VALUES (_ecolgroupid, _ecolgroup)
  RETURNING ecolgroupid
$function$
