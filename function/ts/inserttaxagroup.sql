CREATE OR REPLACE FUNCTION ts.inserttaxagroup(_taxagroupid character varying, _taxagroup character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.taxagrouptypes (taxagroupid, taxagroup)
  VALUES (_taxagroupid, _taxagroup)
$function$
