CREATE OR REPLACE FUNCTION ti.gettaxagroupsfordatasettype(_datasettypeid integer)
 RETURNS TABLE(taxagroupid character varying, taxagroup character varying)
 LANGUAGE sql
AS $function$
select      tx.taxagroupid, 
            tgt.taxagroup
FROM        ndb.taxagrouptypes AS tgt 
  INNER JOIN         ndb.taxa AS tx  ON tx.taxagroupid = tgt.taxagroupid
  INNER JOIN    ndb.variables AS var ON     tx.taxonid = var.taxonid
  INNER JOIN ndb.dsdatasample AS dss ON dss.variableid = var.variableid
  INNER JOIN     ndb.datasets AS ds  ON   ds.datasetid = dss.datasetid
WHERE ds.datasettypeid = _datasettypeid
group by ds.datasettypeid,
          tx.taxagroupid, 
		  tgt.taxagroup


$function$
