CREATE OR REPLACE FUNCTION ti.getisopretreatmenttypes()
RETURNS xxxxx
LANGUAGE SQL
AS $function$
SELECT      isopretreatmenttypeid, isopretreatmenttype, isopretreatmentqualifier
 FROM ndb.isopretratmenttypes;
$function$