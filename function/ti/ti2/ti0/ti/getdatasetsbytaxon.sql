CREATE OR REPLACE FUNCTION ti.getdatasetsbytaxon(_taxon character varying)
 RETURNS TABLE(taxonname character varying, variableelement character varying, datasetid integer, datasettype character varying, collectionunitid integer, siteid integer, sitename character varying)
 LANGUAGE sql
AS $function$
SELECT ndb.taxa.taxonname, ndb.variableelements.variableelement, ndb.datasets.datasetid, ndb.datasettypes.datasettype, ndb.collectionunits.collectionunitid, 
       ndb.sites.siteid, ndb.sites.sitename
FROM   ndb.taxa INNER JOIN
       ndb.variables ON ndb.taxa.taxonid = ndb.variables.taxonid INNER JOIN
       ndb.data ON ndb.variables.variableid = ndb.data.variableid INNER JOIN
       ndb.samples ON ndb.data.sampleid = ndb.samples.sampleid INNER JOIN
       ndb.datasets ON ndb.samples.datasetid = ndb.datasets.datasetid INNER JOIN
       ndb.datasettypes ON ndb.datasets.datasettypeid = ndb.datasettypes.datasettypeid INNER JOIN
       ndb.collectionunits ON ndb.datasets.collectionunitid = ndb.collectionunits.collectionunitid INNER JOIN
       ndb.sites ON ndb.collectionunits.siteid = ndb.sites.siteid LEFT OUTER JOIN
       ndb.variableelements ON ndb.variables.variableelementid = ndb.variableelements.variableelementid
GROUP BY ndb.taxa.taxonname, ndb.variableelements.variableelement, ndb.datasets.datasetid, ndb.collectionunits.collectionunitid, ndb.sites.siteid, 
                      ndb.sites.sitename, ndb.datasettypes.datasettype
HAVING ndb.taxa.taxonname = _taxon
$function$
