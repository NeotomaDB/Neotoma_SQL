CREATE OR REPLACE FUNCTION ti.getecolgroupstable()
 RETURNS TABLE(taxonid integer, ecolsetid integer, ecolgroupid character varying)
 LANGUAGE sql
AS $function$
SELECT taxonid, ecolsetid, ecolgroupid
FROM ndb.ecolgroups 
$function$
