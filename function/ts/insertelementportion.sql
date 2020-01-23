CREATE OR REPLACE FUNCTION ts.insertelementportion(_portion character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.elementportions (portion)
  VALUES (_portion)
  RETURNING portionid
$function$
