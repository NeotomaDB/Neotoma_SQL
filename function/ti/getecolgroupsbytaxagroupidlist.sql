CREATE OR REPLACE FUNCTION ti.getecolgroupsbytaxagroupidlist(_taxagrouplist text)
 RETURNS TABLE(taxonid integer, ecolsetid integer, ecolgroupid character varying, recdatecreated timestamp without time zone, recdatemodified timestamp without time zone)
 LANGUAGE sql
AS $function$
SELECT ndb.ecolgroups.*
FROM ndb.ecolgroups INNER JOIN ndb.taxa ON ndb.ecolgroups.taxonid = ndb.taxa.taxonid
WHERE (ndb.taxa.taxagroupid IN (
	SELECT unnest(string_to_array(_taxagrouplist,'$'))::text
	))
$function$
