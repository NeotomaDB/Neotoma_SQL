CREATE OR REPLACE FUNCTION ti.getelementtaxagroupid(_taxagroupid character varying, _elementtypeid integer)
 RETURNS TABLE(elementtaxagroupid integer)
 LANGUAGE sql
AS $function$
SELECT elementtaxagroupid
FROM ndb.elementtaxagroups
WHERE (taxagroupid = _taxagroupid) AND (elementtypeid = _elementtypeid) 
$function$
