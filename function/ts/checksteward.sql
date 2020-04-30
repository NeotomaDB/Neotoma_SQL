CREATE OR REPLACE FUNCTION ts.checksteward(_username character varying,
                                           _pwd character varying)
 RETURNS TABLE(stewardid integer,
               authorized integer)
 LANGUAGE sql
AS $function$

  SELECT stewardid, authorized
  FROM ts.stewardauthorization
  WHERE username = _username AND pwd = _pwd

$function$
