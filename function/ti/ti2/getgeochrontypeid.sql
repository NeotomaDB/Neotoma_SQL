CREATE OR REPLACE FUNCTION ti.getgeochrontypeid(_geochrontype character varying)
 RETURNS TABLE(geochrontypeid integer)
 LANGUAGE sql
AS $function$

SELECT     geochrontypeid
FROM       ndb.geochrontypes
where     (geochrontype = _geochrontype)


$function$
