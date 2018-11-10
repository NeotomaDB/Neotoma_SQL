CREATE OR REPLACE FUNCTION ts.insertfaciestypes(_facies character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.faciestypes (facies)
  VALUES (_facies)
  RETURNING faciesid
$function$;
