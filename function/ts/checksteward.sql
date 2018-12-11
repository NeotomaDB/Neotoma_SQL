
CREATE OR REPLACE FUNCTION ts.checksteward(
  _username CHARACTER VARYING,
  _pwd CHARACTER VARYING)
RETURNS TABLE(stewardid INTEGER, authorized INTEGER)
LANGUAGE sql
AS $function$

  SELECT stewardid, authorized
  FROM ts.stewardauthorization
  WHERE username = _username AND pwd = _pwd

$function$
