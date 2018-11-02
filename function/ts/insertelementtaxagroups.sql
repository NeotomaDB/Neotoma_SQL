CREATE OR REPLACE FUNCTION ts.insertelementtaxagroups(_taxagroupid character varying, _elementtypeid integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.elementtaxagroups (taxagroupid, elementtypeid)
  VALUES (_taxagroupid, _elementtypeid)
  RETURNING elementtaxagroupid
$function$;
