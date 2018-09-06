CREATE OR REPLACE FUNCTION ti.getagetypeid(agetype character varying)
 RETURNS TABLE(agetypeid integer)
 LANGUAGE sql
AS $function$

SELECT     agetypeid
FROM       ndb.agetypes at
WHERE     at.agetype = $1

$function$
