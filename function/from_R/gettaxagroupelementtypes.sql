CREATE OR REPLACE FUNCTION ti.gettaxagroupelementtypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      ndb.elementtaxagroups.taxagroupid, ndb.elementtypes.elementtype
 FROM ndb.elementtaxagroups inner join
                      ndb.elementtypes on ndb.elementtaxagroups.elementtypeid = ndb.elementtypes.elementtypeid;
$function$