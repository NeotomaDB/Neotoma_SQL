CREATE OR REPLACE FUNCTION ts.updatespecimennisp(_specimenid integer, _nisp double precision, _contactid integer)
 RETURNS void
 LANGUAGE sql
AS $function$

  UPDATE ndb.specimens
  SET nisp = _nisp
  WHERE specimenid = _specimenid;


$function$
