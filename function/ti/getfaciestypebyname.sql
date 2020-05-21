CREATE OR REPLACE FUNCTION ti.getfaciestypebyname(_facies character varying)
 RETURNS TABLE(faciesid integer, facies character varying)
 LANGUAGE sql
AS $function$
  SELECT faciesid, facies
  FROM ndb.faciestypes
  WHERE facies ILIKE _facies
$function$
