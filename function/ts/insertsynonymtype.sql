CREATE OR REPLACE FUNCTION ts.insertsynonymtype(_synonymtype character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.synonymtypes(synonymtype)
  VALUES (_synonymtype)
  RETURNING synonymtypeid
$function$
