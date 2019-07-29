CREATE OR REPLACE FUNCTION ts.insertelementsymmetry(_symmetry character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.elementsymmetries (symmetry)
  VALUES (_symmetry)
  RETURNING symmetryid
$function$
