CREATE OR REPLACE FUNCTION ts.updatechroncontroltype(_chroncontroltypeid integer, _chroncontroltype character varying)
 RETURNS void
 LANGUAGE sql
AS $function$
	UPDATE ndb.chroncontroltypes AS cct
	SET   chroncontroltype = _chroncontroltype
	WHERE cct.chroncontroltypeid = _chroncontroltypeid
$function$
