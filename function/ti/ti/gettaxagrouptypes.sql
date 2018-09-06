CREATE OR REPLACE FUNCTION ti.gettaxagrouptypes()
 RETURNS TABLE(taxagroupid character varying, taxagroup character varying)
 LANGUAGE sql
AS $function$
SELECT taxagroupid, 
       taxagroup
 FROM ndb.taxagrouptypes;
$function$
