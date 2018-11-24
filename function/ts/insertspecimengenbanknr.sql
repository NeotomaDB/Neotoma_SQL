CREATE OR REPLACE FUNCTION ts.insertspecimengenbanknr(
   _specimenid integer,
   _genbanknr character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.specimengenbank(specimenid, genbanknr)
  VALUES (_specimenid, _genbanknr)
$function$;
