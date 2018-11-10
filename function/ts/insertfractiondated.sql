CREATE OR REPLACE FUNCTION ts.insertfractiondated(_fraction character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.fractiondated (fraction)
  VALUES (_fraction)
  RETURNING fractionid
$function$;
