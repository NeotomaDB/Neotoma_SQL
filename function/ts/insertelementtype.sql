CREATE OR REPLACE FUNCTION ts.insertelementtype(_elementtype character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.elementtypes (elementtype)
  VALUES (_elementtype)
  RETURNING elementtypeid
$function$
