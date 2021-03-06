CREATE OR REPLACE FUNCTION ap.gettaxagrouptypes()
 RETURNS TABLE(taxagroupid character varying, taxagroup character varying)
 LANGUAGE sql
AS $function$
SELECT t.taxagroupid, tgt.taxagroup
FROM ndb.variables AS v INNER JOIN
ndb.taxa AS t ON t.taxonid = v.taxonid INNER JOIN
ndb.taxagrouptypes AS tgt ON tgt.taxagroupid = t.taxagroupid
WHERE t.taxagroupid NOT IN('AMB','UPA','GCH','BIM','LAB','LOI','CHR', 'CHM','SED','WCH')
GROUP BY t.taxagroupid, tgt.taxagroup
ORDER BY tgt.taxagroup
$function$
