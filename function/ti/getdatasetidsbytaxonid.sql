CREATE OR REPLACE FUNCTION ti.getdatasetidsbytaxonid(_taxonid integer)
 RETURNS TABLE(datasetid integer)
 LANGUAGE sql
AS $function$
	SELECT ds.datasetid
	FROM ndb.datasets AS ds
    INNER JOIN ndb.samples AS smp ON ds.datasetid = smp.datasetid
    INNER JOIN ndb.data AS dt ON smp.sampleid = dt.sampleid
    INNER JOIN ndb.variables AS var ON dt.variableid = var.variableid
	GROUP BY ds.datasetid, var.taxonid
	HAVING var.taxonid = _taxonid;
$function$
