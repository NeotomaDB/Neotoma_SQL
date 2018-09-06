CREATE OR REPLACE FUNCTION ti.getgeochrontypestable()
 RETURNS TABLE(geochrontypeid integer, geochrontype character varying)
 LANGUAGE sql
AS $function$

SELECT     geochrontypeid, geochrontype 
FROM          ndb.geochrontypes


$function$
