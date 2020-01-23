CREATE OR REPLACE FUNCTION ap.getelementtypes(_taxagroupid character varying)
 RETURNS TABLE(elementtypeid integer, elementtype character varying)
 LANGUAGE sql
AS $function$
    select et.elementtypeid, et.elementtype
    from ndb.elementtypes as et inner join
    ndb.elementtaxagroups as etg on etg.elementtypeid = et.elementtypeid
    where etg.taxagroupid = _taxagroupid
    order by elementtype
$function$
