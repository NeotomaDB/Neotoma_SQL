CREATE OR REPLACE FUNCTION ts.insertelementtaxagroupsymmetry(_elementtaxagroupid integer, _symmetryid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.elementtaxagroupsymmetries (elementtaxagroupid, symmetryid)
  VALUES (_elementtaxagroupid, _symmetryid)
$function$;
