CREATE OR REPLACE FUNCTION ti.getchronconroltypebyname(_chroncontroltype character varying)
 RETURNS TABLE(chroncontroltypeid integer, chroncontroltype character varying, higherchroncontroltypeid integer)
 LANGUAGE sql
AS $function$
SELECT chroncontroltypeid,
       chroncontroltype,
       higherchroncontroltypeid
FROM ndb.chroncontroltypes
WHERE (chroncontroltype ILIKE _chroncontroltype);
$function$
