CREATE OR REPLACE FUNCTION ti.getvariabletaxonid(_variableid integer)
 RETURNS TABLE(taxonid integer)
 LANGUAGE sql
AS $function$
SELECT vr.taxonid
FROM
                   ndb.variables AS vr
WHERE     (vr.variableid = variableid)

$function$
