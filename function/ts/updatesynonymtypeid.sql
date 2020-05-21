CREATE OR REPLACE FUNCTION ts.updatesynonymtypeid(_synonymid integer, _synonymtypeid integer)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.synonyms AS syn
	SET    synonymtypeid = _synonymtypeid
	WHERE  syn.synonymid = _synonymid
$function$
