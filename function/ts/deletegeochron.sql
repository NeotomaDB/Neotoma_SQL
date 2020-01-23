CREATE OR REPLACE FUNCTION ts.deletegeochron(_geochronid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  DELETE FROM ndb.geochroncontrols AS gcc
  WHERE gcc.geochronid = _geochronid;

  DELETE FROM ndb.geochronology AS gc
  WHERE gc.geochronid = _geochronid;
$function$
