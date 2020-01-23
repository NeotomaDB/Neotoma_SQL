CREATE OR REPLACE FUNCTION ts.insertecolgroup(_taxonid integer, _ecolsetid integer, _ecolgroupid character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.ecolgroups(taxonid, ecolsetid, ecolgroupid)
  VALUES (_taxonid, _ecolsetid, _ecolgroupid)
$function$
