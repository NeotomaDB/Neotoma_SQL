CREATE OR REPLACE FUNCTION ti.gettaxaecolgroupsbydatasettypelist(_datasettypeids character varying)
 RETURNS TABLE(taxagroupid character varying, taxagroup character varying, ecolgroupid character varying, ecolgroup character varying)
 LANGUAGE sql
AS $function$
select tgt.taxagroupid, 
        tgt.taxagroup,
		eg.ecolgroupid,
		egt.ecolgroup
from   ndb.taxa AS tx 
  inner join            ndb.ecolgroups AS eg  ON tx.taxonid = eg.taxonid
  inner join        ndb.ecolgrouptypes AS egt ON eg.ecolgroupid = egt.ecolgroupid 
  inner join          ndb.ecolsettypes AS est ON eg.ecolsetid = est.ecolsetid
  inner join             ndb.variables AS var ON tx.taxonid = var.taxonid 
  inner join          ndb.dsdatasample AS dss ON var.variableid = dss.variableid
  inner join              ndb.datasets AS ds  ON dss.datasetid = ds.datasetid 
  right outer join ndb.taxagrouptypes AS tgt on tx.taxagroupid = tgt.taxagroupid
where     (ds.datasettypeid in (SELECT unnest(string_to_array(_datasettypeids, ','))::int))
group by tgt.taxagroupid, 
          tgt.taxagroup, 
          egt.ecolgroupid, 
          egt.ecolgroup,
		  eg.ecolgroupid
order by tgt.taxagroup, egt.ecolgroup

$function$
