CREATE OR REPLACE FUNCTION ti.getelementtypesbytaxagroupid(_taxagroupid character varying)
 RETURNS TABLE(elementtypeid integer, elementtype character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.elementtaxagroups.elementtypeid, ndb.elementtypes.elementtype
FROM   ndb.elementtaxagroups inner JOIN
                      ndb.elementtypes ON ndb.elementtaxagroups.elementtypeid = ndb.elementtypes.elementtypeid
WHERE ndb.elementtaxagroups.taxagroupid = _taxagroupid;
$function$
