CREATE OR REPLACE FUNCTION ti.getdatasetidsbytaxonid(_taxonid integer)
 RETURNS integer
 LANGUAGE sql
AS $function$
SELECT ndb.datasets.datasetid
FROM ndb.datasets INNER JOIN
     ndb.samples ON ndb.datasets.datasetid = ndb.samples.datasetid INNER JOIN
     ndb.data ON ndb.samples.sampleid = ndb.data.sampleid INNER JOIN
     ndb.variables ON ndb.data.variableid = ndb.variables.variableid
GROUP BY ndb.datasets.datasetid, ndb.variables.taxonid
HAVING ndb.variables.taxonid = _taxonid;
$function$
