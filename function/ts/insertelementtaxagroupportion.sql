CREATE OR REPLACE FUNCTION ts.insertelementtaxagroupportion(_elementtaxagroupid integer, _portionid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.elementtaxagroupportions (elementtaxagroupid, portionid)
  VALUES (_elementtaxagroupid, _portionid)
$function$;
