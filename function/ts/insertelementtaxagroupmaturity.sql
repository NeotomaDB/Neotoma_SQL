CREATE OR REPLACE FUNCTION ts.insertelementtaxagroupmaturity(_elementtaxagroupid integer, _maturityid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.elementtaxagroupmaturities (elementtaxagroupid, maturityid)
  VALUES (_elementtaxagroupid, _maturityid)
$function$
