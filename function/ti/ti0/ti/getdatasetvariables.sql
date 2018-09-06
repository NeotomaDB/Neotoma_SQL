CREATE OR REPLACE FUNCTION ti.getdatasetvariables(_datasetid integer)
 RETURNS TABLE(variableid integer, taxoncode character varying, taxonname character varying, author character varying, variableelement character varying, variableunits character varying, variablecontext character varying)
 LANGUAGE sql
AS $function$ 
SELECT ndb.data.variableid, ndb.taxa.taxoncode, ndb.taxa.taxonname, ndb.taxa.author, ndb.variableelements.variableelement,
		ndb.variableunits.variableunits, ndb.variablecontexts.variablecontext
FROM ndb.variableelements RIGHT OUTER JOIN
	ndb.samples INNER JOIN
 	ndb.data ON ndb.samples.sampleid = ndb.data.sampleid INNER JOIN
 	ndb.variables ON ndb.data.variableid = ndb.variables.variableid INNER JOIN
	ndb.taxa ON ndb.variables.taxonid = ndb.taxa.taxonid LEFT OUTER JOIN
	ndb.variablecontexts ON ndb.variables.variablecontextid = ndb.variablecontexts.variablecontextid LEFT OUTER JOIN
	ndb.variableunits ON ndb.variables.variableunitsid = ndb.variableunits.variableunitsid ON 
	ndb.variableelements.variableelementid = ndb.variables.variableelementid
WHERE ndb.samples.datasetid = _datasetid
GROUP BY ndb.data.variableid, ndb.taxa.taxoncode, ndb.taxa.taxonname, ndb.taxa.author, ndb.variableelements.variableelement,
	ndb.variableunits.variableunits, ndb.variablecontexts.variablecontext
$function$
