CREATE OR REPLACE FUNCTION ts.insertgeochroncontrol(_chroncontrolid integer, _geochronid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.geochroncontrols (chroncontrolid, geochronid)
  VALUES (_chroncontrolid, _geochronid)
$function$
