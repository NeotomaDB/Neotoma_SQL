CREATE OR REPLACE FUNCTION ti.getchronconroltypebyname(cctype character varying)
 RETURNS TABLE(chroncontroltypeid integer, chroncontroltype character varying, higherchroncontroltypeid integer)
 LANGUAGE sql
AS $function$
SELECT chroncontroltypeid, chroncontroltype, higherchroncontroltypeid
FROM ndb.chroncontroltypes
WHERE (chroncontroltype = cctype);
$function$
