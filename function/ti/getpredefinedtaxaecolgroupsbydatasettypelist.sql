CREATE OR REPLACE FUNCTION ti.getpredefinedtaxaecolgroupsbydatasettypelist(_datasettypeids character varying)
 RETURNS TABLE(taxagroupid character varying, taxagroup character varying, ecolgroupid character varying, ecolgroup character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.datasettaxagrouptypes.taxagroupid, ndb.taxagrouptypes.taxagroup, ndb.ecolgroups.ecolgroupid,
		ndb.ecolgrouptypes.ecolgroup
FROM ndb.datasettaxagrouptypes INNER JOIN
                      ndb.taxa ON ndb.datasettaxagrouptypes.taxagroupid = ndb.taxa.taxagroupid INNER JOIN
                      ndb.ecolgroups ON ndb.taxa.taxonid = ndb.ecolgroups.taxonid INNER JOIN
                      ndb.taxagrouptypes ON ndb.datasettaxagrouptypes.taxagroupid = ndb.taxagrouptypes.taxagroupid INNER JOIN
                      ndb.ecolgrouptypes ON ndb.ecolgroups.ecolgroupid = ndb.ecolgrouptypes.ecolgroupid
WHERE ndb.datasettaxagrouptypes.datasettypeid IN (SELECT unnest(string_to_array(_datasettypeids,'$'))::int)
GROUP BY ndb.datasettaxagrouptypes.taxagroupid, ndb.taxagrouptypes.taxagroup, ndb.ecolgroups.ecolgroupid, ndb.ecolgrouptypes.ecolgroup
ORDER BY ndb.datasettaxagrouptypes.taxagroupid;

$function$
