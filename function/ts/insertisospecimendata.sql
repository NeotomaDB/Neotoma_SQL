CREATE OR REPLACE FUNCTION ts.insertisospecimendata(_dataid integer, _specimenid integer, _sd double precision DEFAULT NULL::double precision)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.isospecimendata(dataid, specimenid, sd)
  VALUES (_dataid, _specimenid, _sd)
$function$
