CREATE OR REPLACE FUNCTION ts.deletechronology(_chronologyid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  WITH gccs AS (
    SELECT     gcc.chroncontrolid, gcc.geochronid
    FROM ndb.chronologies AS ch
    JOIN ndb.chroncontrols AS cc ON ch.chronologyid = cc.chronologyid
    JOIN ndb.geochroncontrols AS gcc ON cc.chroncontrolid = gcc.chroncontrolid
    WHERE ch.chronologyid = _chronologyid
  )
  DELETE FROM ndb.geochroncontrols AS gcc
  WHERE (SELECT gccs.chroncontrolid FROM gccs) = gcc.chroncontrolid AND
        (SELECT gccs.geochronid FROM gccs) = gcc.geochronid;

  DELETE FROM ndb.chronologies AS ch
  WHERE ch.chronologyid = _chronologyid;
$function$
