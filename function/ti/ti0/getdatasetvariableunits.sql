CREATE OR REPLACE FUNCTION ti.getdatasetvariableunits(_datasetid integer)
 RETURNS TABLE(variableunitsid integer, variableunits character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.variableunits.variableunitsid, ndb.variableunits.variableunits
FROM ndb.datasets inner join
                      ndb.samples on ndb.datasets.datasetid = ndb.samples.datasetid inner join
                      ndb.data on ndb.samples.sampleid = ndb.data.sampleid inner join
                      ndb.variables on ndb.data.variableid = ndb.variables.variableid inner join
                      ndb.variableunits on ndb.variables.variableunitsid = ndb.variableunits.variableunitsid
group by ndb.datasets.datasetid, ndb.variableunits.variableunits, ndb.variableunits.variableunitsid
having      (ndb.datasets.datasetid = _datasetid);
$function$
