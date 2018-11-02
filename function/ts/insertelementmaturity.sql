CREATE OR REPLACE FUNCTION ts.insertelementmaturity(_maturity character varying)
 RETURNS integer
 LANGUAGE sql
AS $function$
  INSERT INTO ndb.elementmaturities (maturity)
  VALUES (_maturity)
  RETURNING maturityid
$function$;
