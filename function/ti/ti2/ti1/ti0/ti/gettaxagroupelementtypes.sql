CREATE OR REPLACE FUNCTION ti.gettaxagroupelementtypes()
 RETURNS TABLE(taxagroupid character varying, elementtype character varying)
 LANGUAGE sql
AS $function$
SELECT etg.taxagroupid, 
        et.elementtype
 FROM ndb.elementtaxagroups AS etg
 INNER JOIN
   ndb.elementtypes AS et ON etg.elementtypeid = et.elementtypeid;
$function$
