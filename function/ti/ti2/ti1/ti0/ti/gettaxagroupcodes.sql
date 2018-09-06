CREATE OR REPLACE FUNCTION ti.gettaxagroupcodes()
 RETURNS TABLE(taxagroupid character varying, taxagroup character varying, ecolsetid integer, ecolsetname character varying, ecolgroupid character varying, ecolgroup character varying)
 LANGUAGE sql
AS $function$
SELECT 
  tgt.taxagroupid, 
  tgt.taxagroup, 
  est.ecolsetid, 
  est.ecolsetname,
  egt.ecolgroupid, 
  egt.ecolgroup
FROM
  ndb.taxa AS tx
  INNER JOIN           ndb.ecolgroups AS eg  ON     tx.taxonid = eg.taxonid 
  INNER JOIN       ndb.ecolgrouptypes AS egt ON eg.ecolgroupid = egt.ecolgroupid 
  INNER JOIN         ndb.ecolsettypes AS est ON   eg.ecolsetid = est.ecolsetid 
  RIGHT OUTER JOIN ndb.taxagrouptypes AS tgt ON tx.taxagroupid = tgt.taxagroupid
GROUP BY 
  tgt.taxagroup, 
  egt.ecolgroup, 
  tgt.taxagroupid, 
  egt.ecolgroupid, 
  est.ecolsetid, 
  est.ecolsetname
ORDER BY 
  tgt.taxagroup,
  egt.ecolgroup;
$function$
