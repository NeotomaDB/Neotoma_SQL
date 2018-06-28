CREATE OR REPLACE FUNCTION ti.getgeochrontypestable()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      geochrontypeid, geochrontype 
 FROM ndb.geochrontypes;
$function$