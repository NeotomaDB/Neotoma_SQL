CREATE OR REPLACE FUNCTION ti.getchroncontroltypestable()
 RETURNS TABLE(chroncontroltypeid integer, chroncontroltype character varying, higherchroncontroltypeid integer)
 LANGUAGE sql
AS $function$
SELECT chroncontroltypeid, chroncontroltype, higherchroncontroltypeid
FROM ndb.chroncontroltypes;
$function$
