CREATE OR REPLACE FUNCTION ts.deletegeochroncontrol(_chroncontrolid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  DELETE FROM ndb.geochroncontrols AS gcc
  WHERE (gcc.chroncontrolid = _chroncontrolid);

  DELETE FROM ndb.chroncontrols AS cc
  WHERE (cc.chroncontrolid = _chroncontrolid);
$function$
