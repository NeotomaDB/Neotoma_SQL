CREATE OR REPLACE FUNCTION ti.getelementtypesbytaxagroupid(_taxagroupid character varying)
 RETURNS TABLE(elementtypeid integer, elementtype character varying)
 LANGUAGE sql
AS $function$
SELECT etx.elementtypeid, et.elementtype
FROM   ndb.elementtaxagroups AS etx INNER JOIN
                      ndb.elementtypes AS et ON etx.elementtypeid = et.elementtypeid
WHERE etx.taxagroupid = _taxagroupid;
$function$
