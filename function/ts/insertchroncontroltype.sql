CREATE OR REPLACE FUNCTION ts.insertchroncontroltype(_chroncontroltype character varying, _higherchroncontroltypeid integer)
RETURNS void
 LANGUAGE sql
AS $function$
INSERT INTO ndb.chroncontroltypes(chroncontroltype, higherchroncontroltypeid)
VALUES (_chroncontroltype, _higherchroncontroltypeid)
RETURNING chroncontroltypeid
$function$;
