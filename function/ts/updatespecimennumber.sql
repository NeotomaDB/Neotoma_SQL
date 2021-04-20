CREATE OR REPLACE FUNCTION ts.updatespecimennumber(_specimenid integer, _specimennr integer)
 RETURNS void
 LANGUAGE sql
AS $function$
  UPDATE ndb.specimens
  SET specimennr = _specimennr
  WHERE specimentid = _specimenid
$function$
